# bitcoin

bitcoin最初的模型就完全仅仅是转账和签名，这里没智能合约什么事情。

所以理解bitcoin最简单的方式就是把它视作一个账本，你在账本上会记录什么呢？排除掉赊账的用户case，某年某月某日A给B转账xx元。

时间在区块链上没有意义，通过上一章我们可以知道区块链上我们不关心时间只关注块高，那么剩下的只有A给B转账xx元这件事了，钱在区块链上是币。

## utxo & tx

[Unspent transaction output](https://en.wikipedia.org/wiki/Unspent_transaction_output)，我相信你可以在网上找到讲解非常清楚的视频或文章，在我找到的那份guide上也有[介绍](https://github.com/yeasy/blockchain_guide/blob/master/06_bitcoin/design.md)。所以这里只说我个人的理解。

先简述下，每一个地址上都会有若干个utxo，你可以撕毁一批utxo然后创建等额的utxo，至此完成交易。

假定你地址A上有3块和2块，一共两笔utxo，你要给地址B打去4块，你需要撕毁这两个utxo，并且按照规则你会多1块的utxo，你可以打回给你自己。

| inputs | | outputs |
| --- | --- | ---|
| A 3 |...| B 4 |
| A 2 |...| A 1 |

但是在比特币的世界里，一个地址不建议被重复使用，因此output里的A你可以改成你的另一个地址C，此时C就是所谓的找零地址。

| inputs | | outputs |
| --- | --- | ---|
| A 3 |...| B 4 |
| A 2 |...| C 1 |


bitcoin上的每一笔交易都会得到一笔交易的hashid，我们可以随便捞一条交易去看，比如guide里提到的blockchain.com，我们找一笔[NP完全的交易](https://www.blockchain.com/explorer/transactions/btc/3cd997fb35d1c7d410be885d116d99ca705d5ceaad400ab8e97556575dc2446a)

这笔交易记录的是这么一件事

[](_images/bitcoin_example0.png)

这是提交给节点的原始json字符串

```
{
  "txid": "3cd997fb35d1c7d410be885d116d99ca705d5ceaad400ab8e97556575dc2446a",
  "size": 1413,
  "version": 2,
  "locktime": 0,
  "fee": 7100,
  "inputs": [
    {
      "coinbase": false,
      "txid": "d2ca00982ee92a00a7e1797e319fdfaa8cbd5d9748e311faaad8c61689cb1820",
      "output": 0,
      "sigscript": "47304402202b31d121a4d50b37bd0cf72482fc66b5af7bd1530f4ba77601dd510a719832d90220761c85e5555486faa59c30cba50c534f5be0c014cb8f47e610dd91863162de770121031277e88390c528ef8efac312d77d0566f756ed54046b8ba557a15b088b86e20b",
      "sequence": 4294967295,
      "pkscript": "76a914536ffa992491508dca0354e52f32a3a7a679a53a88ac",
      "value": 635449634,
      "address": "18cBEMRxXHqzWWCxZNtU91F5sbUNKhL5PX",
      "witness": []
    },
    {
      "coinbase": false,
      "txid": "9e45287a14ead2386e4c0eb83b312a68a518719ea402c432546907bb1c2bf156",
      "output": 0,
      "sigscript": "47304402204df69679618f85604837815aefce44295d9ec4866e0777ad8083798f43fc6a5602207f2fa9ad81c3575ac75103031e76867744b7faffe29abfe53bb60ec11f21debc0121031277e88390c528ef8efac312d77d0566f756ed54046b8ba557a15b088b86e20b",
      "sequence": 4294967295,
      "pkscript": "76a914536ffa992491508dca0354e52f32a3a7a679a53a88ac",
      "value": 654558555,
      "address": "18cBEMRxXHqzWWCxZNtU91F5sbUNKhL5PX",
      "witness": []
    },
    {
      "coinbase": false,
      "txid": "2a888cbc273933f396cd06be36f51289e7537a93b4a952889e614d745fe71680",
      "output": 0,
      "sigscript": "473044022017e09a57e99285c2ba595e8eb4833dd2e9c3f84f8bce5eacad99a87b3598783002204b6a74c2cd64c3a8a5dd9a81985f888584a134b8e09640976ff42925cf254d2f0121031277e88390c528ef8efac312d77d0566f756ed54046b8ba557a15b088b86e20b",
      "sequence": 4294967295,
      "pkscript": "76a914536ffa992491508dca0354e52f32a3a7a679a53a88ac",
      "value": 659017029,
      "address": "18cBEMRxXHqzWWCxZNtU91F5sbUNKhL5PX",
      "witness": []
    },
    {
      "coinbase": false,
      "txid": "867dfda3e69497d39ac60b843c2273db8e5ed68e056700aad7f4cb313c79f9a7",
      "output": 0,
      "sigscript": "4730440220680672cdcf1c59573a2ec7655c9e6db897e34ef4cba18b1a04fcbb2ffcba11da02203313c903660a9027c5deb08da46d1e9a5f89dd3b8dae68f73516fb0720e2f8d10121031277e88390c528ef8efac312d77d0566f756ed54046b8ba557a15b088b86e20b",
      "sequence": 4294967295,
      "pkscript": "76a914536ffa992491508dca0354e52f32a3a7a679a53a88ac",
      "value": 683423336,
      "address": "18cBEMRxXHqzWWCxZNtU91F5sbUNKhL5PX",
      "witness": []
    },
    {
      "coinbase": false,
      "txid": "51bc2cf79e95c8d6867e5c058185f0f9dde4827b7a02496368a802cf2b6d6baf",
      "output": 0,
      "sigscript": "473044022037fcfee36417f4c6ad3d5195c2018f521cb7038d0754969dc9f9d8629e5a3902022014120dc665f78f3f10976ea672298c0dfaad59ebbe07e2653888839a671b44620121031277e88390c528ef8efac312d77d0566f756ed54046b8ba557a15b088b86e20b",
      "sequence": 4294967295,
      "pkscript": "76a914536ffa992491508dca0354e52f32a3a7a679a53a88ac",
      "value": 640601324,
      "address": "18cBEMRxXHqzWWCxZNtU91F5sbUNKhL5PX",
      "witness": []
    },
    {
      "coinbase": false,
      "txid": "1b8858913609d5a2552c53d1d42359280f2f0dee635bd7a1d9f6c05f825afab8",
      "output": 0,
      "sigscript": "47304402204276ce41fc1910c400bbf72fe5c24e62f3c1652ec9f60000d4d6ff0554330b1e02207deae4a7e21a48839e936fea3b03f564c25edbfdf5a0854df4a137fcd33360690121031277e88390c528ef8efac312d77d0566f756ed54046b8ba557a15b088b86e20b",
      "sequence": 4294967295,
      "pkscript": "76a914536ffa992491508dca0354e52f32a3a7a679a53a88ac",
      "value": 684477314,
      "address": "18cBEMRxXHqzWWCxZNtU91F5sbUNKhL5PX",
      "witness": []
    },
    {
      "coinbase": false,
      "txid": "c6266aec7bc79a25d413ee2d9041889b95f291de58873749534ca021b8f39ff1",
      "output": 0,
      "sigscript": "47304402206f8a4194bc33a7ec708089f67134aa7efe7855963c687554b00b40f289a26f9a0220212ffa370bec0f60caec6d8ebf3565ef7b08dd5101864df948e018023566c29f0121031277e88390c528ef8efac312d77d0566f756ed54046b8ba557a15b088b86e20b",
      "sequence": 4294967295,
      "pkscript": "76a914536ffa992491508dca0354e52f32a3a7a679a53a88ac",
      "value": 639736716,
      "address": "18cBEMRxXHqzWWCxZNtU91F5sbUNKhL5PX",
      "witness": []
    }
  ],
  "outputs": [
    {
      "address": "129x5KwZLQxqDm6BWgkvQmQBt6dArvitga",
      "pkscript": "76a9140ca96d6c6a27658697a6706fc72bc1e4713748e188ac",
      "value": 500000000,
      "spent": true,
      "spender": {
        "txid": "c0dffe976619d94577c1fc7f3aa47ac80572ab0954b4b85f9fd8c920bd4393ec",
        "input": 0
      }
    },
    {
      "address": "159qB3dyCs8g5RbKvfE7PPdPk7zghvcTS7",
      "pkscript": "76a9142d8c0b35cf8e56389634560ad53243244b99679988ac",
      "value": 500000000,
      "spent": true,
      "spender": {
        "txid": "c0dffe976619d94577c1fc7f3aa47ac80572ab0954b4b85f9fd8c920bd4393ec",
        "input": 1
      }
    },
    {
      "address": "17XGWYECsoeMUTD1xNYFr7H6rhTKZySxBL",
      "pkscript": "76a914478a2e1800400c52fdb6e005611791850f302d7388ac",
      "value": 9992900,
      "spent": true,
      "spender": {
        "txid": "de99e6212f836775151d4c79848fa37aaeaf0c97cc08ea1b4f8fb4d92f05c616",
        "input": 0
      }
    },
    {
      "address": "12YCLDgGpnWBRLkyKo8sW9mfRhYcaUaVWe",
      "pkscript": "76a91410de7ac2fcdbc2ba9282988ac72b8b7d43b5978d88ac",
      "value": 500000000,
      "spent": true,
      "spender": {
        "txid": "5a2fe1f477d7d17825542650c79031bd953b117d6c59195209f920c2a5e252b1",
        "input": 0
      }
    },
    {
      "address": "1ARCPYzc3D8KAkoDGkGmxErETx7R2NDHo4",
      "pkscript": "76a914674c9f3e646e3d103c32ea884d7aaaa512cc9a1e88ac",
      "value": 500000000,
      "spent": true,
      "spender": {
        "txid": "5a2fe1f477d7d17825542650c79031bd953b117d6c59195209f920c2a5e252b1",
        "input": 1
      }
    },
    {
      "address": "19DeHFeh5yMcC24ABB5CiJR3jk97UioGyh",
      "pkscript": "76a9145a251e262654ef68a4146640f3ad4b40b832a74d88ac",
      "value": 500000000,
      "spent": true,
      "spender": {
        "txid": "b102ab173e9830a8077fe601f6cb77bf20b64dbf56cbee36b344a032e49d1484",
        "input": 0
      }
    },
    {
      "address": "1DJzzorUT8VZg6iaCtkgRf4yZAPJvUNoM2",
      "pkscript": "76a9148708fe739a7cd5ec8da0712edcb07bfa01bf013488ac",
      "value": 87263908,
      "spent": true,
      "spender": {
        "txid": "db0e678e1b8bef5c635da36ec3fad10544f2ed61beb5a1ab461dfce05b637592",
        "input": 1
      }
    },
    {
      "address": "1KiwT4JkH9MJ4HzGPMbyzHQmHJXEudMwTV",
      "pkscript": "76a914cd60c53f0fe7871a8590174112b2696e1b83055988ac",
      "value": 500000000,
      "spent": true,
      "spender": {
        "txid": "b102ab173e9830a8077fe601f6cb77bf20b64dbf56cbee36b344a032e49d1484",
        "input": 1
      }
    },
    {
      "address": "1Hgba5S6EmYWrMMgCTQcb7ceNGTeWcSXAJ",
      "pkscript": "76a914b6ff17c64913e490d08d12885d2f08fe2fbd9c3688ac",
      "value": 500000000,
      "spent": true,
      "spender": {
        "txid": "b102ab173e9830a8077fe601f6cb77bf20b64dbf56cbee36b344a032e49d1484",
        "input": 2
      }
    },
    {
      "address": "1Nz1Dh7YeqR2iApYhwJWppV8YWUGppLzZP",
      "pkscript": "76a914f12288b087df5cb5390b2c191faf2bc453a370a688ac",
      "value": 500000000,
      "spent": true,
      "spender": {
        "txid": "cd8c44e7f663679f141cd7bbafb1a5ae9d1a475519cd530d47375d00f81d3b21",
        "input": 0
      }
    },
    {
      "address": "1P4Xvr9byRqGroTAQBdnPCHQh5hYpYA2i5",
      "pkscript": "76a914f1fdd53644221b07ce90847a7d7599aa31ed619d88ac",
      "value": 500000000,
      "spent": true,
      "spender": {
        "txid": "cd8c44e7f663679f141cd7bbafb1a5ae9d1a475519cd530d47375d00f81d3b21",
        "input": 1
      }
    }
  ],
  "block": {
    "height": 780300,
    "position": 6
  },
  "deleted": false,
  "time": 1678538546,
  "rbf": false,
  "weight": 5652
}
```

txid即交易的hash，size是交易字节数，version版本号，locktime不认识，不知道对应哪个BIP，去找下矿工这块就会清楚，fee是给矿工的费用。

input是输入的utxo，coinbase标记是否为挖矿系统奖励，里面的txid是该utxo来源的交易id，然后签名，序列号，脚本字串，金额，地址，witness是给多重签名用的。

output是目标输出的utxo，没啥特别东西。

block区块信息。rbf不认识，不重要。

里面[pkscript](https://github.com/yeasy/blockchain_guide/blob/master/06_bitcoin/design.md#%E4%BA%A4%E6%98%93%E8%84%9A%E6%9C%AC)可以写一些简单的if-else条件，以太拓展的就是这块逻辑，加上了循环，满足了图灵完备就变成了合约。比特上也可以写一点简单的脚本，就是pkscript这里了。

明白了utxo和交易过程，接下来是地址。

## address

非对称公私钥是个很常见的概念了。私钥到公钥很常见，对公钥做一些hash计算即可得到地址。（一般34个字符，排除掉了lO这种视觉模糊的可能就33个也有，忘记哪个位置是校验码了，当过矿工的可能清楚一点……）

privkey => pubkey => address

比特币对地址有3种类型

+ 最早以1开头对普通地址P2PKH （Pay 2 Pubkey Hash）当然虽然legacy了但现在依然有效。

+ 以3开头的P2SH （Pay 2 Script Hash）就是segwit 隔离见证，就是将签名数据和交易分开，缩小一下总体的交易字符串长度，

+ bc1开头的 bech32 格式，[BIP173](https://github.com/bitcoin/bips/blob/master/bip-0173.mediawiki)，就segwit设计，目的就是压缩交易字符串，一个块打包更多交易，让矿工计算收益变高。

至此我们就看到了比特币的扩展玩法。

### schnorr signature

bitcoin简单讲讲大概就这些东西了……
[多重签名](https://en.wikipedia.org/wiki/Schnorr_signature)现在用的是这个算法，就pkscript里的if-else脚本实现，工科生实现的角度其实难度不大，可以让你用n of m的方式共同持有一个地址，背后的数学原理比较复杂，我也不知道适不适合在这里展开说……先咕着吧，反正我也是看wiki学的。

### xprivkey

之前提到找零地址，你反复用一个地址说起来比较危险，所以建议用不同的地址，那么加一个path管理，BIP44嘛。xprivkey path=0/0/1 计算出一个privkey，懒得看你把它当mapkey看就行……这样的话就能自动计算出你的下一个地址，其实就是方便用户用的。

xprivkey => privkey => pubkey => address

## 助记词

纸键这个也简单，[BIP39](https://github.com/MetaMask/bip39/tree/master)，就是拿一个wordlist映射一下你的xprivkey。

上面这些都有很简单的库做，生成个地址发一笔交易一共没几行代码，有兴趣可以自己上测试网络玩玩的，比特币简单说说就这点东西了。抛开数学部分和很多细枝末节的还是很简单的。

## lightning
