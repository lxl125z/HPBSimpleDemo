//
//  HPBApi.swift
//  TestAppJump
//
//  Created by 刘晓亮 on 2018/12/29.
//  Copyright © 2018 Zhaoxi Network. All rights reserved.
//

import Foundation
import UIKit

//HPBWallet的Scheme
fileprivate let HPBWalletScheme : String  = "hpbwallet";
fileprivate let kParamKey: String      = "param";
fileprivate let kCallbackKey: String   = "callback";
fileprivate let kQuerySDK : String     = "hpbwalletsdk";

class HPBWalletApi{
    
    /// 默认打开
    public static var  isDebugLog: Bool = false 
    
    /// 注册后会以参数形式传递给HPBWallet,并注册为当前应用的Schemes
    private static var urlSchemes: String?
    ///  注册URL Schemes
    ///  - parameter urlSchemes: 在Xcode工程info.plist-> URL types -> URL Schemes里添加
    public static func registerAppURLSchemes(_ urlSchemes: String){
        HPBWalletApi.urlSchemes = urlSchemes
    }
    
    ///  检查HPB Wallet是否已被用户安装
    ///  - returns: 支持返回true，不支持返回false。
    public static func isHPBWalletInstalled() -> Bool{
        guard let url = URL(string: "\(HPBWalletScheme)://")else{return false}
        if UIApplication.shared.canOpenURL(url){
          return true
        }
        return false
    }
    

    ///  向 HPBWallet 发起请求
    ///  - parameter req: 登录/转账
    ///  - returns: true/false
    @discardableResult
    public static func sendReq(_ req: HPBWalletBaseReq) -> Bool{
        guard HPBWalletApi.urlSchemes != nil else {
            HPBWalletApiRely.debugLog("urlSchemes不能为空")
            return false
        }
        var  param = req.convertParamsToDic()
        //  callBackUrl拼接
        let callBackValue = "\(HPBWalletApi.urlSchemes.noneNull)://\(kQuerySDK)?action=\(req.action.noneNull)"
        param.updateValue(callBackValue, forKey: kCallbackKey)
        let paramsStr = HPBWalletApiRely.toJSONString(param)
        if paramsStr.noneNull.isEmpty{
            HPBWalletApiRely.debugLog("生成openUrl的参数失败")
            return false
        }
        // openUrl 字符串
        var urlStr = "\(HPBWalletScheme)://hpb.io?param=\(paramsStr.noneNull)"
        urlStr = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed).noneNull
        guard let openUrl = URL(string: urlStr) else {
            HPBWalletApiRely.debugLog("openUrl失败")
            return false
        }
        return HPBWalletApiRely.openURL(openUrl)
    }
    
    
    ///  处理HPBWallet的回调
    ///  在AppDelegate -(application:openURL:options:)方法里调用
    ///  - parameter url: 回调的URL
    ///  - parameter block: 响应模型
    public static func handleURL(_ url: URL,result: ((HPBWalletResp)->Void)? = nil) -> Bool{
        if url.scheme == HPBWalletApi.urlSchemes.noneNull{
            if let resp = respWithURL(url){
                result?(resp)
                return true
            }
        }
        return false
    }
    
   
}

extension HPBWalletApi{
    
   
    /// 解析回调的deurl
    fileprivate static func respWithURL(_ url: URL) -> HPBWalletResp? {
        
        //获取请求参数字符串(Url编码后的)
        let query = url.query.noneNull
        guard let paramDict = HPBWalletApi.getURLParameters(query)
            else{
                return nil
        }
        if paramDict["action"] != nil && paramDict["result"] != nil{
            let resp = HPBWalletResp()
            resp.action = paramDict["action"] as? String
            resp.result = HPBWalletRespResult(paramDict["result"])
            resp.data = paramDict
            return resp
        }
        return nil
    }

    
    /// Open URL截取URL中的参数
    fileprivate static func getURLParameters(_ paramStr: String)-> [String: Any]?{
        //嵌套函数
        func componentsKeyAndValue(_ aParamStr: String) -> (key: String,value: String)?{
            guard aParamStr.contains("=") else{
                HPBWalletApiRely.debugLog("⚠️请检查URL参数是否为key=value形式")
                return nil
            }
            let pairArr =  aParamStr.components(separatedBy: "=")
            let key = (pairArr.first?.removingPercentEncoding).noneNull
            let value = (pairArr.last?.removingPercentEncoding).noneNull
            if key.isEmpty || value.isEmpty{
                HPBWalletApiRely.debugLog("⚠️URL参数中存在空值，如果需要传空请忽略")
            }
            return (key,value)
        }
        
        // 多个参数拼装
        var paramDic: [String: Any] = [:]
        if  paramStr.contains("&"){
            let urlParamArr = paramStr.components(separatedBy: "&")
            urlParamArr.forEach {
                guard let aParamTup = componentsKeyAndValue($0)else{return}
              paramDic.updateValue(aParamTup.value, forKey: aParamTup.key)
            }
        }else{
        //单个参数拼接
            guard let aParamTup = componentsKeyAndValue(paramStr) else{return nil}
            paramDic.updateValue(aParamTup.value, forKey: aParamTup.key)
        }
        return paramDic
    }
    
}

