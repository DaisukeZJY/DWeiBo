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
    
    
    func sendStatus(text:String, image:UIImage?, successCallBack:@escaping (_ status: Status) ->(), errorCallBack:@escaping (_ error: Error)->()) {
        var path = "2/statuses/"
        let params = ["access_token": UserAccount.loadAccount()?.access_token, "status":text]
        if image != nil {
            // 发送图片微博
            path += "upload.json"
            post(path, parameters: params, constructingBodyWith: { (formData) in
                // 将数据转为二进制
                let data = UIImagePNGRepresentation(image!)
                
                // 上传数据
                /*
                 第一个参数：需要上传的二进制数据
                 第二个参数：服务器对应哪个字段名称
                 第三个参数：文件的名称（大部分服务器可以随便写）
                 第四个参数：数据类型，通用类型application/octet-stream
                 */
                formData.appendPart(withFileData: data!, name: "pic", fileName: "pic.png", mimeType: "application/octet-stream")
                
            }, progress: nil, success: { (_, json) in
                // 关闭发送页面
                let status = Status(dict: (json as! [String : AnyObject]))
                successCallBack(status)
            }) { (_, error) in
                errorCallBack(error )
            }
            
        } else {
            path += "update.json"
            post(path, parameters: params, progress: nil, success: { (_, json) in
                let status = Status(dict: (json as! [String : AnyObject]))
                successCallBack(status)
            }) { (_, error) in
                errorCallBack(error as NSError )
            }
        }
    }
    
    
}



