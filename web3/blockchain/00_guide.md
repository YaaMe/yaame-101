# 导言

区块链的[历史](https://github.com/yeasy/blockchain_guide/blob/master/01_history/bitcoin.md)不想做过多赘述，感兴趣的自行翻阅吧，画饼的部分请自助消化……反正从bitcoin涉及的领域范围来讲，我更倾向于中本聪是一个匿名组织而不是人的推论。

## 什么是区块链

简单讲就是一个分布式单链表。

复杂一点点讲，block-1包含hash(block-0)的信息，同时依赖block-0的数据，block-2包含hash(block-1)的信息，同时依赖block-1的数据。场景简单点就转钱，每一个block只记录这一轮账目的转移情况。

比如古代有个小小的村落有一群猛男在愉快地捡树枝，这村子里每个人都有一个账本，只有相同的内容才会被大家认为是事实。

于是block-0法外狂徒张三在海边捡了100块贝壳（PoW），全村的人都看见了。

然后block-1张三给了暴徒李四70块贝壳，附张三的签名。

然后block-2李四给二愣子王五20块贝壳，附李四的签名。

你手里什么都没有，如果你要在block-3里写你也在海边捡到了100块贝壳，你得让全村的人看见，行不通。

你想伪造李四给了你50块贝壳，你需要攻破现有的非对称公私钥体系，拿到李四的私钥，这条路也行不通。

那么你只能伪造记录，你得去修改block-2的数据，而这样照理类推，你需要一直修改到创世区块。

那么接下来只需要确保数据源可信，这就涉及到各种 Proof-of-XXX 的证明机制了。这个在下面的篇章里讲。同样这里还有个双花问题，也先咕一咕。

## MECE分类

区块链本身作为一个分布式的账本数据库，从节点属性上分三种 私链/联盟链/公链。

私链：某人独立拥有全部的节点。此时的区块链就是一个单纯的分布式数据库，我也不知道有啥商业价值，区块链的主要价值之一是信用转移，即原本依赖于人的信用被通过数学转移到了一串hash值，而私链显然无法证明数据映射，信托背后依旧是个人或者中心集体，除非节点角色是个中间件，但中间件角色就可以玩成联盟链。定义上看测试链属于这种吧。额，可能还有现阶段的数字人民币。

联盟链：某几个人加起来拥有全部的节点。体感上政府项目更多，一般是不进公众视野的。这时候的联盟链有2种玩法：一种是将这些节点作为某个平台或者服务提供。另一种是不同的实体间相互制约验证用。这里由于不涉及公链，信用依旧由背后的实体担当，玩法会更多样一点，你可以声明各种节点的角色，你可以做信息不完全透明，只做部分数据验证，因为只需要确保数据不会被篡改，交易撮合要用的时候再互相验hash就行了。可以使用的场景其实很多，比如简历求职的信息，租房房源和租客的信息，各种供应链。当然这里面涉及商家利益，你要真能找到几家比如51和boss联合做这个，他们大概既没这个技术实力，也未必觉得能通过这个赚钱……至于政府项目就懂的都懂，混口饭吃……

公链：进入公众视野的一般是这个，因为面向每一个用户都可以独自做节点（但其实还是集中在少部分人手里，毕竟有钱就是可以这样为所欲为……）。bitcoin，ethereum，ipfs，但公链受到的制约会多很多，毕竟你不能相信任何一个节点，所以每一个节点都只能做相同的事情，这里还没有到合约的部分，单纯说节点，比如ipfs存文件就是存文件，你不能划一批节点存更高贵的文件……或者你不能像cdn那样划一个区域的节点只做边缘计算，不过你可以给节点设立角色自己选择，比如你是想提供cpu，还是提供存储，这个是可以的，但这取决于节点用户意愿，分布上属于听天由命的类型，而且目前来讲还没有看到那么复杂的设计，因为这里激励机制也会变得挺复杂的，公链的激励机制是个涉及社区运营的复杂玩意儿了，有点超出我的知识范围。