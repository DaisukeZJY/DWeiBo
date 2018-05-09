//
//  User.swift
//  DWeiBo
//
//  Created by DaiSuke on 2018/5/9.
//  Copyright © 2018年 DaiSuke. All rights reserved.
//

import UIKit

class User: NSObject {

    /// 用户ID
    var id: Int = 0
    /// 名称
    var name:String?
    /// 用户头像地址（中图）
    var profile_image_url:String?
    /// 认证，ture是
    var verified: Bool = false
    /// 用户的认证类型， -1没有认证， 0认证用户， 2.3.5企业认证， 220达人
    var verified_type: Int = -1
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    // 打印当前模型
    var properties = ["id", "name", "profile_image_url", "verified", "verified_type"]
    override var description: String{
        let dict = dictionaryWithValues(forKeys: properties)
        return "\(dict)"
    }
    
}
