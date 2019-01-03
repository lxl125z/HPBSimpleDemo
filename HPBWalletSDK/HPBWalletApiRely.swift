//
//  HPBWalletApiRely.swift
//  TestAppJump
//
//  Created by 刘晓亮 on 2018/12/29.
//  Copyright © 2018 Zhaoxi Network. All rights reserved.
//  HPBWalletApi中依赖的方法

import Foundation
import UIKit


//MARK: -String可选类型安全解包
protocol  OptionalSting {}
extension String : OptionalSting {}
extension Optional where Wrapped: OptionalSting {
    /// 对可选类型的String(String?)安全解包
    var noneNull: String {
        if let value = self as? String {
            return value
        } else {
            return ""
        }
    }
}



//MARK: -HPBWalletApiRely
class HPBWalletApiRely {
    
    /// Debug打印
    static func debugLog(_ items: Any?..., file: String = #file, line: Int = #line) {
        #if DEBUG
        if !HPBWalletApi.isDebugLog{return}
        let shortcutFileName = (file as NSString).lastPathComponent
        let printingString = ">>[\(shortcutFileName)]--[line:\(line)]:"
        print(printingString)
        // 如果直接print(items), 打印出来的东西会在最外层带有一对"[]"
        for item in items {
            if item != nil {
                print(item!)
            } else {
                print("nil")
            }
        }
        #endif
    }
    
    /// 转换成json的形式
    static func toJSONString(_ obj: Any) -> String?{
        if !JSONSerialization.isValidJSONObject(obj){
            return nil
        }
        guard let data = try? JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)else{
            return nil
        }
        let jsonStr = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String?
        return jsonStr
    }
    
    /// openURL
    static func openURL(_ url: URL)-> Bool{
        if UIApplication.shared.canOpenURL(url){
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
            return true
        }
        return false
    }
    
    
}
