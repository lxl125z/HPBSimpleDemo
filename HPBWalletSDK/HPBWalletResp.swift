//
//  HPBWalletResp.swift
//  TestAppJump
//
//  Created by 刘晓亮 on 2018/12/29.
//  Copyright © 2018 Zhaoxi Network. All rights reserved.
//

import Foundation

/// 状态返回
enum HPBWalletRespResult: Int{
    case cancel = -1
    case faile = 0
    case success = 1
    //自定义初始化方法
    init?(_ value: Any?){
        if let intValue = value as? Int{
            self.init(rawValue: intValue)
        }else if let strValue = value as? String,let intValue = Int(strValue){
            self.init(rawValue: intValue)
        }else{
            return nil
        }
    }
}


/// 响应处理模型
class  HPBWalletResp{
    
    /// 处理类型
    var action: String?
    
    /// 返回状态
    var result: HPBWalletRespResult?
    
    /// 返回的数据
    var data: [String: Any]?
    
}
