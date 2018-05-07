//
//  UserAccount.swift
//  DWeiBo
//
//  Created by DaiSuke on 2018/5/7.
//  Copyright © 2018年 DaiSuke. All rights reserved.
//

import UIKit

class UserAccount: NSObject {

    var access_token:String?
    var expires_in:NSNumber?
    var uid:String?
    
    override init() {
        
    }
    init(dict:[String:AnyObject]){
        access_token = dict["access_token"] as? String
        expires_in = dict["expires_in"] as? NSNumber
        uid = dict["uid"] as? String
    }
    
    override var description: String{
        let properties = ["access_token", "expires_in", "uid"]
        let dict = self.dictionaryWithValues(forKeys: properties)
        return "\(dict)"
    }
    
}
