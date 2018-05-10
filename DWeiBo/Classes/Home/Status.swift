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
    var created_at:String? {
        didSet{
            let date = NSDate.dateWithString(time: created_at!)
            created_at = date.descDate
        }
    }
    /// 微博ID
    var id:Int = 0
    /// 微博信息内容
    var text:String?
    /// 微博来源
    var source:String? {
        didSet{
            // <a href=\"http://app.weibo.com/t/feed/4fuyNj\" rel=\"nofollow\">即刻笔记</a>
            // 截取字符串
            if let str = source {
                // 获取开始截取的位置
                let startLocation = (str as NSString).range(of: ">").location+1
                // 获取截取的长度
                let length = (str as NSString).range(of: "<", options: NSString.CompareOptions.backwards).location - startLocation
                source = "来自:"+(str as NSString).substring(with: NSRange(location: startLocation, length: length))
            }
        }
    }
    /// 配图数组
    var pic_urls: [[String:AnyObject]]? {
        didSet {
            // 初始化数组
            storedPicURLs = [NSURL]()
            for dict in pic_urls! {
                if let urlStr = dict["thumbnail_pic"]{
                    // 将字符串转为URL保存到数组中
                    storedPicURLs?.append(NSURL(string: urlStr as! String)!)
                }
            }
        }
    }
    
    /// 保存当前微博所有配图的URL
    var storedPicURLs:[NSURL]?
    
    
    /// 用户信息
    var user:User?
    
    /// 加载微博数据
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
                
//                finishBlock(models, nil)
                cacheStatusImages(list: models, finishBlock: finishBlock)
                
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
    
    /// 缓存微博图片
    class func cacheStatusImages(list:[Status], finishBlock:@escaping (_ models:[Status]?, _ error:NSError?) ->()) {
        
        // 创建一个数组
        let group = DispatchGroup()
        for status in list {
            
            // 判断当前微博是否有配图，没有就直接跳过
//            if status.storedPicURLs == nil {
//                continue
//            }
            
            // 新语法
            // 如果条件为nil，那么久会执行else后面的语句
            guard status.storedPicURLs != nil else {
                continue
            }
            
            for url in status.storedPicURLs! {
                // 将当前的下载操作添加到组
                group.enter()
                
                SDWebImageManager.shared().downloadImage(with: url as URL, options: SDWebImageOptions(rawValue: 0), progress: nil) { (_, _, _, _, _) in
                    // 离开当前组
                    group.leave()
                }
            }
        }
        
        // 当所有图片都下载完毕再通过闭包通用调用者
        group.notify(queue: DispatchQueue.main) {
            // 能够来到这个地方，一定是所有图片都下载完毕
            finishBlock(list, nil)
        }
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
