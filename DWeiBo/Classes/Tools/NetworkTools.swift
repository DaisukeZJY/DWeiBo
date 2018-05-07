//
//  NetworkTools.swift
//  DWeiBo
//
//  Created by DaiSuke on 2018/5/7.
//  Copyright © 2018年 DaiSuke. All rights reserved.
//

import UIKit
import AFNetworking

class NetworkTools: AFHTTPSessionManager {

    static let tools:NetworkTools = {
        let url = NSURL(string: "https://api.weibo.com/")
        let net = NetworkTools(baseURL: url! as URL)
        
        // 设置接收数据类型
        net.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json", "text/json", "text/javascript", "text/plain") as? Set<String>
        
        return net
    }()
    
    class func shareNetworkTools() -> NetworkTools{
        return tools
    }
}



