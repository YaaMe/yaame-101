# Web3

很多人会问我的第一个问题是web3和blockchain的区别是什么。web3其实是吹嘘起来的一个概念。个人理解的话，可能blockchain更偏向底层的技术实现，web3大概包含了基于blockchain搭建的一系列可行的服务群。所以最外层的分类还是把名字给了web3。

接下来会逐渐开始理blockchain相关的一些知识点。

# blockchain

## layer

突然看到有人提起layer01234，我读了读定义，我不知道这个概念是谁提出来的，但我感觉这些人自己都没搞清楚，因为连个wiki都没有。感觉像是binance自己糊出来的，这帮人搞的看看热闹就好……

### layer0

传输层，我不知道为什么P2P的网络协议如QUIC是怎么被恬不知耻地归类到区块链的layer0上来的。。。但他们说是就是吧，总之看下来这是硬件设施层的东西

### layer1

数据层/网络层/共识层/激励层，听着很唬人是吧，你直接说节点不就完了……

### layer2

合约层/应用层，能把合约和基于合约的应用构建放在一起我也不知道吐槽啥好。

- - -

还是谈下自己的理解吧，大概过程是这样的，底层的硬件不谈，首先是substrate的框架，直接抽[源码](https://github.com/paritytech/substrate/blob/d97a18851f9da0b1c299daa8fb18022794065779/client/service/src/client/client.rs#L101)看，我锁了个commit号省的更新后指不对……放心，粗略讲一讲。细的直接看文档，可以顺便学学rust不错的，几百个宏而已不要怕……
这个是作为节点的client，你看到看到struct上挂载的结构体，大概是一个节点的功能，你当然可以继续扩展。
一个peer[节点启动](https://github.com/paritytech/substrate/blob/d97a18851f9da0b1c299daa8fb18022794065779/bin/node/cli/src/service.rs#L313)，首先是网络初始化，构建offchain worker，然后进行rpc处理，开始进入共识处理，联盟链可能有选主，总之跟共识层算法有关，共识结束节点注册在线，进入client主逻辑，区块更新过程（import_block）不谈太多，读数据没关系但写数据会要进行共识，然后抢到tx会去call节点的 [executor](https://github.com/paritytech/substrate/blob/d97a18851f9da0b1c299daa8fb18022794065779/client/service/src/client/call_executor.rs#L163)，拿到当前记录的最新区块ID，然后构建runtime的state machine，runtime我没记错的话即为合约的执行沙盒，好像还是个wasm，时间隔得有点久不是很确定，完成后提交数据。反正节点大概就这些活，具体细的你可以调offchain worker去做，你当然也可以在上面挂其他的peer或者逻辑，这样可以和其他的链交互，当然你在链下offchain里去做也无所谓，具体实现方式其实很自由。
然后这里提到了runtime的合约执行沙盒，你可以定义沙盒上的bridge，也就可以自定义沙盒，但一般通用的合约编写语言是solidity，它的沙盒环境你高兴可以fork一个加功能……但理解上不如直接在里面挂以太的peer做跨链交互，合约这块会在另一个部分讲。这里也牵涉到密码学或者说数学的处理，这个也会另外分一块讲。
合约接触的是用户提交一条条tx，准确说是一条字符串，而提交字符串的就是外部用户了，合约能接受的字符串也是一个bridge，用这个bridge的就是上层应用建筑了比如钱包或者dapp，合约与合约之间也可以通过该bridge通信。而至于基于合约建立的系统和基于dapp建立的服务群，又是另一个故事，dapp更接近现代常见的应用与产品。

整个节点 合约 应用的关系简单理解大概就是这样分别通过2个bridge进行通信交互，计算过程由密码学进行保障。

后续会讲账本的不可篡改，公私钥等，慢慢来……
