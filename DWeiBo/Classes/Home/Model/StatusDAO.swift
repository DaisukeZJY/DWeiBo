//
//  StatusDAO.swift
//  DWeiBo
//
//  Created by DaiSuke on 2018/5/25.
//  Copyright © 2018年 DaiSuke. All rights reserved.
//

import UIKit

/// 数据访问层
class StatusDAO: NSObject {
    
    /// 清除过期的数据
    class func cleanStatuses() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "en")
        
        let date = NSDate(timeIntervalSinceNow: -60)
        let dateStr = formatter.string(from: date as Date)
        
        // 定义SQL语句
        let sql = "DELETE FROM T_Status WHERE createDate <= '\(dateStr)';"
        
        // 执行SQL语句
        SQLiteManager.share().dbQueue?.inDatabase({ (db) in
            db?.executeUpdate(sql, withArgumentsIn: nil)
        })
    }

    /*
     1、从本地数据中获取
     2、如果本地有，直接返回
     3、从网络获取
     4、将从网络获取的数据缓存起来
     */
    /// 加载微博数据
    class func loadStatuses(since_id:Int, max_id:Int, finished:@escaping ([[String:AnyObject]]?, _ error:Error?) ->()){
        // 1、从本地数据库中获取
        loadCacheStatuses(since_id: since_id, max_id: max_id) { (array) in
            // 如果本地有，直接返回
            if !array.isEmpty{
                print("从数据库中获取")
                finished(array, nil)
                return
            }
            
            // 从网络获取
            let path = "2/statuses/home_timeline.json"
            var params = ["access_token":UserAccount.loadAccount()!.access_token]
            // 下拉刷新
            if since_id > 0 {
                params["since_id"] = "\(since_id)"
            }
            
            // 上拉刷新
            if max_id > 0 {
                params["max_id"] = "\(max_id - 1)"
            }
            
            NetworkTools.shareNetworkTools().get(path, parameters: params, progress: nil, success: { (_, json) in
                let dict = json as! [String: AnyObject]
                let array = dict["statuses"] as! [[String: AnyObject]]
                
                // 缓存微博数据
                cacheStatuses(statuses: array)
                
                // 返回数据
                finished(array, nil)
            }) { (_, error) in
                finished(nil, error)
            }
        }
    }
    
    
    /// 读取缓存数据
    class func loadCacheStatuses(since_id:Int, max_id:Int, finished:@escaping ([[String:AnyObject]])->()){
        // 定义SQL语句
        var sql = "SELECT * FROM T_Status \n"
        if since_id > 0 {
            sql += "WHERE statusId > \(since_id) \n"
        } else if max_id > 0 {
            sql += "WHERE statusId <= \(since_id) \n"
        }
        
        sql += "ORDER BY statusId DESC \n"
        sql += "LIMIT 20; \n"
        
        // 执行SQL语句
        SQLiteManager.share().dbQueue?.inDatabase({ (db) in
            // 查询数据
            let res = db?.executeQuery(sql, withArgumentsIn: nil)
            
            // 遍历取出查询的数据
            /*
             返回字典数组的原因：通过网络获取返回的也是字典数组
             让本地和网络返回的数据类型保持一致，以便于我们后期处理
             */
            var statuses = [[String:AnyObject]]()
            while res!.next() {
                // 取出数据库存储的一条微博字符串
                let dictStr = res?.string(forColumn: "statusText") as! String
                // 将微博字符串转为字典
                let data = dictStr.data(using: String.Encoding.utf8)!
                let dict = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]
                statuses.append(dict)
            }
            // 返回数据
            finished(statuses)
        })
    }
    
    
    /// 缓存微博数据
    class func cacheStatuses(statuses: [[String:AnyObject]]){
        // 准备数据
        let userId = UserAccount.loadAccount()!.uid!
        
        // 定义SQL语句
        let sql = "INSERT INTO T_Status (statusId, statusText, userId) VALUES (?, ?, ?);"
        
        // 执行SQL语句
        SQLiteManager.share().dbQueue?.inTransaction({ (db, rollback) in
            
            for dict in statuses {
                let statusId = dict["id"]!
                // JSON -> 二进制 -> 字符串
                let data = try! JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
                let statusText = String(data: data, encoding: String.Encoding.utf8)!
                print(statusText)
                if !db!.executeUpdate(sql, withArgumentsIn: [statusId, statusText, userId]){
                    // 如果数据插入失败，就回滚
                    print("数据插入失败")
                    rollback?.pointee = true
                }
                print("数据插入成功")
            }
        })
        
    }
}
