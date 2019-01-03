//
//  HPBApiObject.swift
//  TestAppJump
//
//  Created by 刘晓亮 on 2018/12/29.
//  Copyright © 2018 Zhaoxi Network. All rights reserved.
//

import Foundation

//MARK: -BaseReq
public class HPBWalletBaseReq {
    
    /// 协议名，钱包用来区分不同协议，本协议为HPBWallet
    var `protocol`: String{
        return "HPBWallet"
    }
    /// 协议版本信息
    var version: String{
        return "1.0"
    }
    /// dapp名字
    var dappName: String?
    
    /// dapp图标Url
    var dappIcon: String?
    
    /// dapp行为。登录时，赋值为HPBLogin。支付时，赋值为HPBPay
    var action: String?
    
    /// 参数转化为Dictionary
    func convertParamsToDic() -> [String : Any?]{
        var params: [String : Any?] = [:]
        params.updateValue(self.protocol, forKey: "protocol")
        params.updateValue(self.version,  forKey:  "version")
        params.updateValue(self.dappName, forKey: "dappName")
        params.updateValue(self.dappIcon, forKey: "dappIcon")
        params.updateValue(self.action,   forKey:  "action")
        return params
    }
}


//MARK: -授权登录LoginReq
public class HPBWalletLoginReq: HPBWalletBaseReq {
    
    ///dapp生成的，用于dapp登录验证唯一标识
    var uuID: String?
    
    ///dapp server生成的，用于接受此次登录验证的URL
    var loginUrl: String?
    
    ///登录过期时间，unix时间戳,eg: 1546071823 精确到秒
    var expired: String?
    
    ///其他信息,预留字段，可置空
    var otherInfo: String?
    
    override func convertParamsToDic() -> [String : Any?]{
        var params = super.convertParamsToDic()
        params.updateValue(self.uuID, forKey: "uuID")
        params.updateValue(self.loginUrl, forKey: "loginUrl")
        params.updateValue(self.expired, forKey: "expired")
        params.updateValue(self.otherInfo, forKey: "otherInfo")
        return params
    }
    
}


//MARK: -支付PayReq

public class HPBWalletPayReq: HPBWalletBaseReq{
    
   ///收款人的账户地址
   var to: String?
    
   /// 转账数量。1个HPB就是1
   var amount: String?
    
   /// 转账的token的精度，小数点后面的位数，默认是8位
   var precision: Int = 8
    
   /// 交易的说明信息，钱包在付款UI展示给用户
   var desc: String?
    
   ///过期时间，unix时间戳,eg: 1546071823，精确到秒
   var expired: String?

    override func convertParamsToDic() -> [String : Any?]{
        var params = super.convertParamsToDic()
        params.updateValue(self.to, forKey: "to")
        params.updateValue(self.amount, forKey: "amount")
        params.updateValue(self.precision, forKey: "precision")
        params.updateValue(self.desc, forKey: "desc")
        params.updateValue(self.expired, forKey: "expired")
        return params
    }
}


//MARK: -跳转HPBWallet指定的DAPP的URL
/// 在外部浏览器打开HPBWallet内嵌的DAPP
public class HPBWalletOpenURLReq : HPBWalletBaseReq{
    
    /// dAppURL
    var dappUrl: String?
    
    /// 第三方DApp的描述信息
    var desc: String?
    
    override func convertParamsToDic() -> [String : Any?]{
        var params = super.convertParamsToDic()
        params.updateValue(self.dappUrl, forKey: "dappUrl")
        params.updateValue(self.desc, forKey: "desc")
        return params
    }
    
}
