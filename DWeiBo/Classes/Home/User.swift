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
    var verified_type: Int = -1 {
        didSet{
            switch verified_type {
            case 0:
                verifiedImage = UIImage(named: "avatar_vip")
            case 2,3,5:
                verifiedImage = UIImage(named: "avatar_enterprise_vip")
            case 220:
                verifiedImage = UIImage(named: "avatar_grassroot")
            default:
                verifiedImage = nil
            }
        }
    }
    
    /// 保存当前用户的认证图片
    var verifiedImage:UIImage?
    
    /// 会员等级
    var mbrank: Int = 0 {
        didSet{
            if mbrank > 0 && mbrank < 7 {
                mbrankImage = UIImage(named: "common_icon_membership_level\(mbrank)")
            }
        }
    }
    
    /// 会员图标
    var mbrankImage:UIImage?
    
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
