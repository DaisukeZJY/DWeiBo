//
//  UserAccount.swift
//  DWeiBo
//
//  Created by DaiSuke on 2018/5/7.
//  Copyright © 2018年 DaiSuke. All rights reserved.
//

import UIKit

class UserAccount: NSObject, NSCoding {
    

    var access_token:String?
    var expires_date:Date?
    var expires_in:NSNumber? {
        didSet {
            // 根据过期的描述，生成真正过期时间
//            expires_date = NSDate(timeIntervalSinceNow: (expires_in?.doubleValue)!)
            expires_date = Date(timeIntervalSinceNow: (expires_in?.doubleValue)!)
        }
    }
    var uid:String?
    /// 用户头像地址（大图）
    var avatar_large:String?
    /// 用户昵称
    var screen_name:String?
    
    override init() {
        
    }
    init(dict:[String:AnyObject]){
//        access_token = dict["access_token"] as? String
//        expires_in = dict["expires_in"] as? NSNumber
//        uid = dict["uid"] as? String
        
        super.init()
        setValuesForKeys(dict)
        
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        print(key)
    }
    
    override var description: String{
        let properties = ["access_token", "expires_in", "uid"]
        let dict = self.dictionaryWithValues(forKeys: properties)
        return "\(dict)"
    }
    
    // MARK: - 对外方法
    // 加载用户信息
    func loadUserInfo(finishBlock: @escaping (_ account: UserAccount?, _ error: NSError?)->()) {
        assert(access_token != nil, "没有授权")
        
        let path = "2/users/show.json"
        let params = ["access_token":access_token, "uid":uid]
        
        NetworkTools.shareNetworkTools().get(path, parameters: params, progress: nil, success: { (_, json) in
            print(json as Any)
            if let dict = json as? [String: AnyObject] {
                self.avatar_large = dict["avatar_large"] as? String
                self.screen_name = dict["screen_name"] as? String
                
                // 保存信息
                finishBlock(self, nil)
                return
            }
            finishBlock(nil, nil)
        }) { (_, error) in
            print(error)
            finishBlock(nil, error as NSError)
        }
    }
    
    
    /// 判断是否登录
    class func userLogin() -> Bool {
        return UserAccount.loadAccount() != nil
    }
    
    /// 保存对象到文件中
    func saveAccount() {
//        let filePath = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last! as NSString).appendingPathComponent("account.plist")
        let filePath = "account.plist".cacheDir()
        // 序列化
        NSKeyedArchiver.archiveRootObject(self, toFile: filePath)
    }
    
    // 加载对象
    static var account:UserAccount?
    class func loadAccount() -> UserAccount? {
        if account != nil {
            return account
        }
        
        // 加载
//        let filePath = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last! as NSString).appendingPathComponent("account.plist")
        let filePath = "account.plist".cacheDir()
        account = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? UserAccount
        
        // 判断授权信息是否过期
        if account?.expires_date?.compare(Date()) == ComparisonResult.orderedAscending {
            // 过期
            return nil
        }
        
        return account
    }
    
    
    // MARK: - NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(expires_in, forKey: "expires_in")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(expires_date, forKey: "expires_date")
    }
    
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObject(forKey: "access_token") as? String
        expires_in = aDecoder.decodeObject(forKey: "expires_in") as? NSNumber
        uid = aDecoder.decodeObject(forKey: "uid") as? String
        expires_date = aDecoder.decodeObject(forKey: "expires_date") as? Date
    }
    
}
