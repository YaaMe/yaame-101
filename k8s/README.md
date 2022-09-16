终于将几块碎片连起来了，简单记录一下。

起点还是围绕k8s的object，从建立开始。这次理的是svc，pod相关的一部分。

k8s管理的是一批跑在容器上的应用，image一扔其实管理的是容器。

假定给它的载体是一批机器，ElasticCompute。（懒得管ECS还是EC2了，也不知道GCP是不是不太一样）。理解上机器本身会有它自己的网段划分，自己的IP，那么k8s会至少需要建立一个 Node 作为映射，当然细节不熟，谁去创建谁看对应文档就明白，但先不管这个。只需要先记得所在的node会有自己的network。

k8s在创建时会自己画一个完全独立的网络，内网，局域网，怎么称呼无所谓……会需要声明svc和pod所在的网段，注意这两个cidr不能相交，比如你可以把10.0/8段给svc，172.0/8段给pod。流量从物理层肯定先找到宿主机，node，然后找对应svc入口，然后找到pod，所以大概是这样

node network
……………………………………
svc network
……………………………………
pod network

ps: service mesh的service 指的是k8s的这个svc，我最开始以为是更广义micro service的service，心想这起的还挺玄乎…

总之 svc somehowsomewhere 以某种方式比如绑在了node的某个port上，流量达到svc后，会找它的CNI插件（网口插件，虚拟的二层设备，因此理论上你可以在这上面玩[MPLS](https://zh.wikipedia.org/wiki/%E5%A4%9A%E5%8D%8F%E8%AE%AE%E6%A0%87%E7%AD%BE%E4%BA%A4%E6%8D%A2)这种东西当然性能考虑估计没人会这么玩就是了）翻译给kubeproxy，kubeproxy根据extenraltrafficpolicy决定其行为（local｜cluster，简单说直接丢弃还是转发），但最终会有一个找到pod位置，通过CNI再发给pod就完了。

注意kubeproxy有自己的dns记录，有自己的iptables，所以你在pod内进行dns查询，会得到 svc network 以下的状态，而如果你是在其宿主机上进行dns查询等，由于你在node network 所以是查询不到svc的注册状态的

ingress

ingress描述的是给不同service的流量分发策略，它有自己的svc和pod，但是它传svc不能链式，即指定先传A再传B，显然不能，链式是程序自己的事。svc以label的方式选择挂靠的ingress

label

就一个标签其实没啥好讲的……

namespace

其实和label一样是一种标签

replicaset和replicacontroller

前者控制的是pod的数量，HPA告诉replicacontroller去调整replicaset，replicaset以pod数量是否达标来判定pod运行状态。step滚动更新差不多道理。其实就是不段调整同一个deployment的新旧两个版本的replicaset指定的pod数

istio

envoy

ebpf



碎片先理到这儿
