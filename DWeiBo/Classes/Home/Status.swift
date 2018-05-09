//
//  Status.swift
//  DWeiBo
//
//  Created by DaiSuke on 2018/5/9.
//  Copyright © 2018年 DaiSuke. All rights reserved.
//

import UIKit

class Status: NSObject {
    
    /// 微博创建时间
    var created_at:String?
    /// 微博ID
    var id:Int?
    /// 微博信息内容
    var text:String?
    /// 微博来源
    var source:String?
    /// 配图数组
    var pic_urls: [[String:AnyObject]]?
    
    /// 用户信息
    var user:User?
    
    
    class func loadStatuses(finishBlock:@escaping (_ models:[Status]?, _ error:NSError?) ->()){
        let path = "2/statuses/home_timeline.json"
        let params = ["access_token":UserAccount.loadAccount()!.access_token]
        
        SVProgressHUD.setStatus("loading...")
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        
        NetworkTools.shareNetworkTools().get(path, parameters: params, progress: nil, success: { (_, json) in
            if let dict = json as? [String: AnyObject]{
                // 取出字典数组，转为model数组
                let dictList = dict["statuses"] as! [[String: AnyObject]]
                let models = dictToModel(list: dictList)
                finishBlock(models, nil)
                SVProgressHUD.dismiss()
                return
            }
            SVProgressHUD.dismiss()
        }) { (_, error) in
            finishBlock(nil, error as NSError)
            SVProgressHUD.dismiss()
        }
    }
    
    /// 将字典数组转模型数组
    class func dictToModel(list:[[String:AnyObject]]) -> [Status] {
        var models = [Status]()
        for dict in list {
            models.append(Status(dict: dict))
        }
        return models
    }
    
    /// 字典转模型
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        // 判断当前是否给字典的user赋值
        if "user" == key {
            user = User(dict: value as! [String : AnyObject])
            return
        }
        // 调用父类的方法，按照系统默认处理
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    // 打印当前模型
    var properties = ["created_at", "id", "text", "source", "pic_urls"]
    override var description: String{
        let dict = dictionaryWithValues(forKeys: properties)
        return "\(dict)"
    }
}
