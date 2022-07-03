这里打算扔一套现成的CF worker部署方案。

后续打算思考下结合构建下基于边缘网络的前端构建实践。

得先简单介绍下worker这个东西原理，后面再放一些 CI。不过github action的部分我还没写，个人使用向的还是不太一样。这点后面想有空研究前端构建，想到一些好玩的东西验证下，还得先补补webpack5很久没追溯前端了。最近的话先补补别的基础课（没办法我太菜了）。

## 0.导言

在tap第一次使用worker的原因嘛省的触发敏感条例就抛开不谈，反正看到这个结构就产生了把整个前端页面扔上去的想法，不过当时没有实际业务需求就没有动刀。今年嘛众所周知tap开始推广海外业务，为了优化海外线路就正好假公济私一下，刚好CF也开始出相关博客。优化的原理其实很简单，内容推到边缘网络，用户访问直接就在cdn边缘网络返回了，省的各种跨洋了。哪怕第一次打开也能享受到近乎cdn加速的结果。实际提升数据嘛也不太方便放……脑补一下就行了。

## 1.Worker是什么？

worker是一个跑在分布式边缘网络上的serverless应用(script)。应用的起点由fetch event触发，终点由返回的response构成。熟悉Event的一眼就该明白。准确说，如果你熟悉 serviceworker 直接可以跳过下一段，如果你同时熟悉去中心化结构，可以直接翻(CF文档)[https://developers.cloudflare.com/workers/]理解会更快。

```javascript
addEventListener('fetch', event => {
  event.respondWith(handleRequest(event.request));
});
 
async function handleRequest(request) {
  return new Response('Hello worker!', {
    headers: { 'content-type': 'text/plain' },
  });
}
```

## 2.Worker的工作原理

首先worker的runtime选用V8引擎，接驳了大部分标准的web api。套用一个可参考的设计：service worker。

service worker由2015年提出，跑在浏览器中是独立于js的另一个可供使用的独立线程。它主要用来处理离线网页应用，我们先理解原生的service worker的运行方式（自己去看 (MDN)[https://developer.mozilla.org/zh-CN/docs/Web/API/Service_Worker_API/Using_Service_Workers] 的worker lifecycle）。

由于这是两个线程，所以nodejs的主线程与service worker的通信方式皆为异步提交。

lifecycle：installing → installed → activating → activated → redundant

通常逻辑发生在installed之后，active状态是留给更新使用的，用来处理旧版本worker的缓存之类的

正常apply一个service worker的代码流程：

### register

```javascript
if ('serviceWorker' in navigator) {
  navigator.serviceWorker.register('/sw-test/sw.js', { scope: '/sw-test/' }).then(function(reg) {
    // registration worked
    console.log('Registration succeeded. Scope is ' + reg.scope);
  }).catch(function(error) {
    // registration failed
    console.log('Registration failed with ' + error);
  });
}
```

### install

```javascript
this.addEventListener('install', function(event) {
  event.waitUntil(
    caches.open('v1').then(function(cache) {
      return cache.addAll([
        '/sw-test/',
        '/sw-test/index.html',
        '/sw-test/style.css',
        '/sw-test/app.js',
        '/sw-test/image-list.js',
        '/sw-test/star-wars-logo.jpg',
        '/sw-test/gallery/',
        '/sw-test/gallery/bountyHunters.jpg',
        '/sw-test/gallery/myLittleVader.jpg',
        '/sw-test/gallery/snowTroopers.jpg'
      ]);
    })
  );
});
```

安装完成后就会激活

每次任何被 service worker 控制的资源被请求到时，都会触发 fetch 事件，这些资源包括了指定的 scope 内的文档，和这些文档内引用的其他任何资源（比如 index.html 发起了一个跨域的请求来嵌入一个图片，这个也会通过 service worker 。）

你可以给 service worker 添加一个 fetch 的事件监听器，接着调用 event 上的 respondWith() 方法来劫持我们的 HTTP 响应，然后你用可以用自己的方法来更新他们。

```javascript
this.addEventListener('fetch', function(event) {
  event.respondWith(
    caches.match(event.request)
  );
});
```

以上是一个service worker的玩法。

cloudflare的worker行为与其是极其相近的，区别是，service worker跑在一个浏览器里，cloudflare的worker则跑在他分布式边缘网络的其中一个边缘节点上（注意，这意味着每一个边缘节点都会存储所有正注册的worker）。因此，只需要在原有沙盒的基础上进一步改写和限制用户可调用的API，适配API输出合理行为即可。比如将cache对象接上自己的CDN网络，限制如，正常service worker你依旧可以自定义事件trigger，而cloudflare的event只保留了fetch的event，并自定义了schedule（迫于压力），整个install和activate的环节都不在用户的控制范围内。其他的比如不能在顶层执行async的(特性)[https://github.com/w3c/ServiceWorker/issues/1407]也一并带了过来（因为不想block主线程，这也是event.waitUntil定义的由来，具体可以看链接讨论）

除此之外还有一点不同：service worker其实可以死循环，cloudflare显然不能让用户随随便便写个死循环脚本占完运行时间，所以需要在runtime外再加一个限制。

我们知道对于一个沙盒内的图灵完备的语言脚本，只有两种方式能让它安全运行：

1:gas，即执行前告知脚本的可执行行数（指可量化的计算资源，典型的如阿里云的云计算收费）。在这里显然不太方便。

2:timeout，即执行的脚本一定时间后，强制关闭。

因此cloudflare的worker很合理得拥有一个cpu time的上限执行时间，另外由于install环节由cloudflare托管，这一块同样不能超时，因此对于一个worker script的startup时间和size同样会有限制也就不意外了。

## 3.wasm

另一个从浏览器直接带来的特性就是wasm，worker支持加载wasm

```javascript
const wasmMemory = new WebAssembly.Memory({initial: 512});
const wasmInstance = new WebAssembly.Instance(
// RESIZER_WASM is a global variable created through the Resource Bindings UI (or API).
RESIZER_WASM,
 
// This second parameter is the imports object. Our module imports its memory object (so that
// we can allocate it ourselves), but doesn't require any other imports.
{env: {memory: wasmMemory}})
 
// Define some shortcuts.
const resizer = wasmInstance.exports
```

wasm设计用来处理的是高消耗应用，具体应用需要在service binding功能大量实装后开始考虑。虽然wasm的性能很高，但是js加载交互的性能很差，短运行的效果不是很好，可能用来处理下载，视频会好点？
需要native的性能好到足以忽视数据转换的损耗才行。

## 4.KV