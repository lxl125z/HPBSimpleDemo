
##HPBWallet 协议文档

###简介

场景一：钱包APP内嵌dapp的H5页面，进行登录和支付。

场景二：钱包App扫二维码进行登录和支付，适用于Web版dapp。


##场景一

###登录

>场景：在钱包内打开H5,应用内进行用户登陆信息验证。
>
>业务流程图：

![图片 1.png](https://upload-images.jianshu.io/upload_images/4249667-04d0f6bd9d7339d9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/800)

* 我们会提供一个js中间件，提供js和HPBWallet的交互，便于DApp的h5调用。

* DApp的h5调用`signToLogin(params)`方法，和js中间件交互，发起登录。

* dapp需要传递的参数(json格式)说明：

```
{
    protocol	string   // 协议名，钱包用来区分不同协议，本协议为 HPBWallet
    version     string   // 协议版本信息，如1.0
    blockchain  string   // 公链标识（HPB）
    dappName    string   // dapp名字
    dappIcon    string   // dapp图标 
    action      string   // 赋值为login
    uuID        string   // dapp server生成的，用于此次登录验证的唯一标识   
    expired		number		// 二维码过期时间，unix时间戳
    loginMemo	string      // 登录备注信息，钱包用来展示，可选
}

```

* 钱包对登录相关数据进行签名

``` 
 // 生成sign算法
let data = timestamp + account + uuID + ref     //ref为钱包名，标示来源
sign = ecc.sign(data, privateKey)

```

* HPBWallet签名后，回传给Dapp的参数(json格式)说明:

```
// 请求登录验证的数据格式
{
    protocol   string     // 协议名，钱包用来区分不同协议，本协议为 HPBWallet
    version    string     // 协议版本信息，如1.0
    blockchain string    // 公链标识（HPB）
    timestamp  number     // 当前UNIX时间戳
    sign       string     // ECC签名
    action      string   // 赋值为login
    uuID       string     // dapp server生成的，用于此次登录验证的唯一标识     
    account    string     // HPB地址
    ref        string     // 来源,标识来自于HPBWallet，可以设置成HPB钱包名称
}

```

* DApp收到数据，实现`function getCallback(params) `接收原生回调传值action字段，判断此次行为，并发送到dapp sever验证sign签名数据，返回结果code给dapp判断成功状态。


###支付

>场景：在钱包内打开H5,应用内进行支付。
>
>业务流程图：

![WechatIMG510.jpeg](https://upload-images.jianshu.io/upload_images/4249667-3339805907ee9722.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000)


* DApp的h5调用`startToPay(params)`方法，和js中间件交互，发起支付。

* dapp需要传递的参数(json格式)说明：

```
{
	protocol    string   // 协议名，钱包用来区分不同协议，本协议为 HPBWallet
	version     string   // 协议版本信息，如1.0
	blockchain  string   // 公链标识（HPB）
	isSend      bool     // 是否需要HPBWallet发送签名到主网(默认YES)，YES为需要，NO为不需要，可选
	dappName    string   // dapp名字，用于在钱包APP中展示，可选
	dappIcon    string   // dapp图标Url，用于在钱包APP中展示，可选
	action      string   // 支付时，赋值为pay，必须
	to          string   // 收款人的hpb账号、EOSForce账号或Ethereum地址，必须
	amount      number   // 转账数量(带精度，如1.0000 HPB)，必须
	precision   number   // 转账的token的精度，小数点后面的位数，必须
	desc	    string    // 交易的说明信息，钱包在付款UI展示给用户，最长不要超过128个字节，可选
	expired	    number    // 交易过期时间，unix时间戳
}


```

* 钱包接收到数据后（此步骤会判断支付白名单），生成一笔HPB的转账，提交到HPB主网。(备注：此步骤HPBWallet会添加orderID字段 = account+Nonce传递给HPB Sever记录此次支付记录，和Dapp无关，协议文档中可以不写)


* 钱包回传给DAPP的参数说明：

```
   result      string  //0为用户取消，1为成功,  2为失败
    protocol   string   // 协议名，钱包用来区分不同协议，本协议为 HPBWallet，必须
	version     string   // 协议版本信息，如1.0，必须
	blockchain  string   // 公链标识（HPB），必须
	action      string   // 支付时，赋值为pay，必须
	txID        string   //交易哈希，可选（isSend为YES时必须）
	signature   string   //交易签名，可选（isSend为NO时必须）
	amount      number   // 转账数量(带精度，如1.0000 HPB)，必须
	precision   number   // 转账的token的精度，小数点后面的位数，必须

```

* DApp收到数据，实现`function getCallback(params) `通过action字段，判断支付行为，并将txID发送到dapp sever轮询查询交易状态，并返回dapp判断支付状态。



##场景二

###登录


>场景：使用钱包扫描web网站上二维码登录
>
>业务流程图：

![](https://camo.githubusercontent.com/064e3faaecbbe6fc1a921b141f54ced495a002db/687474703a2f2f6f6e2d696d672e636f6d2f63686172745f696d6167652f3562363538643564653462306265353065616366386630632e706e673f743d31)

* web的dapp生成二维码，HPBWallet扫描登录二维码，包含以下数据：

* dapp生成二维码所需参数(json格式)说明：

```
{
    protocol	string   // 协议名，钱包用来区分不同协议，本协议为 HPBWallet
    version     string   // 协议版本信息，如1.0
    blockchain  string   // 公链标识（HPB）
    dappName    string   // dapp名字
    dappIcon    string   // dapp图标 
    action      string   // 赋值为login
    uuID        string   // dapp server生成的，用于此次登录验证的唯一标识   
    expired		number		// 二维码过期时间，unix时间戳
    loginUrl    string   // dapp server上用于接受登录验证信息的url
    loginMemo	string      // 登录备注信息，钱包用来展示，可选
}

```
* HPBWallet签名后，post数据到Dapp提供的`loginUrl`.参数(json格式)说明如下:

```
// 请求登录验证的数据格式
{
    protocol   string     // 协议名，钱包用来区分不同协议，本协议为 HPBWallet
    version    string     // 协议版本信息，如1.0
    blockchain string    // 公链标识（HPB）
    timestamp  number     // 当前UNIX时间戳
    sign       string     // ECC签名
    action      string   // 赋值为login
    uuID       string     // dapp server生成的，用于此次登录验证的唯一标识     
    account    string     // HPB地址
    ref        string     // 来源,标识来自于HPBWallet，可以设置成HPB钱包名称
}

```

* dapp server收到数据，验证sign签名数据，并返回结果code；若验证成功，则在dapp的业务逻辑中，将该用户设为已登录状态。


###支付

>场景：钱包扫描网站二维码进行支付
>
>业务流程图：

![](https://camo.githubusercontent.com/2b53abbb167c7d4be9399b00abc32b50c13866b1/687474703a2f2f6f6e2d696d672e636f6d2f63686172745f696d6167652f3562363539346261653462303533613039633234666139612e706e673f743d31)

* web的dapp生成支付二维码，HPBWallet扫描二维码支付(此处HPBWallet要判断支付地址白名单)

* dapp生成支付二维码所需参数(json格式)说明：

* dapp生成支付二维码需要传递的参数(json格式)说明：

```
{
	protocol    string   // 协议名，钱包用来区分不同协议，本协议为 HPBWallet
	version     string   // 协议版本信息，如1.0
	blockchain  string   // 公链标识（HPB）
	isSend      bool     // 是否需要HPBWallet发送签名到主网(默认YES)，YES为需要，NO为不需要，可选
	payUrl      string   //dapp Sever地址，为了接收HPBWallet交易签名数据或交易哈希
	dappName    string   // dapp名字，用于在钱包APP中展示，可选
	dappIcon    string   // dapp图标Url，用于在钱包APP中展示，可选
	action      string   // 支付时，赋值为pay，必须
	to          string   // 收款人的hpb账号、EOSForce账号或Ethereum地址，必须
	amount      number   // 转账数量(带精度，如1.0000 HPB)，必须
	precision   number   // 转账的token的精度，小数点后面的位数，必须
	desc	    string    // 交易的说明信息，钱包在付款UI展示给用户，最长不要超过128个字节，可选
	expired	    number    // 交易过期时间，unix时间戳
}

```

* HPBWallet签名后，post数据到Dapp提供的`payUrl `.参数(json格式)说明如下:

```
   result      string  //0为用户取消，1为成功,  2为失败
    protocol   string   // 协议名，钱包用来区分不同协议，本协议为 HPBWallet，必须
	version     string   // 协议版本信息，如1.0，必须
	blockchain  string   // 公链标识（HPB），必须
	action      string   // 支付时，赋值为pay，必须
	txID        string   //交易哈希，可选（isSend为YES时必须）
	signature   string   //交易签名，可选（isSend为NO时必须）
	amount      number   // 转账数量(带精度，如1.0000 HPB)，必须
	precision   number   // 转账的token的精度，小数点后面的位数，必须

```

* dapp sever轮询查询交易状态，并返回dapp判断支付状态。