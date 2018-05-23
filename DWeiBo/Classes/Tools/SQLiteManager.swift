//
//  SQLiteManager.swift
//  DWeiBo
//
//  Created by DaiSuke on 2018/5/23.
//  Copyright © 2018年 DaiSuke. All rights reserved.
//

import UIKit
import SQLite3

class SQLiteManager: NSObject {

    private static let manager:SQLiteManager = SQLiteManager()
    /// 单例
    class func share() ->SQLiteManager{
        return manager
    }
    
    /// 创建一个串行队列
    private let dbQueue = DispatchQueue(label: "com.daisuke.test")
    func execQueueSql(action:@escaping (_ manager:SQLiteManager) ->()) {
        // 开启一个子线程
        dbQueue.async {
            print(Thread.current)
            // 执行闭包
            action(self)
        }
    }
    
    /// 数据库对象
    var db:OpaquePointer? = nil
    
    /// 打开数据库, SQLiteName数据路名称
    func openDB(SQLiteName:String) {
        // 0、拿到数据库的路径
        let path = SQLiteName.docDir()
        print(path)
        let cPath = path.cString(using: String.Encoding.utf8)
        
        // 1、打开数据库
        /*
         1、需要打开的数据库文件的路径，C语言字符串
         2、打开之后的数据库对象（指针），以后所有的数据库操作，都必须拿到这个指针才能进行相关操作
         
         open方法特点：
         1、如果指定路径对应的数据库文件已存在，就会直接打开
         2、如果指定路径对应的数据库文件不存在，就会创建一个新的
         */
        if sqlite3_open(cPath, &db) != SQLITE_OK {
            print("打开数据库失败")
            return
        }
        
        // 创建表
        if createTable() {
            print("创建表成功")
        } else {
            print("创建表失败")
        }
    }
    
    
    func createTable() -> Bool {
        // 1、编写SQL语句
        // 建议：在开发中编写SQL语句，如果语句过长，不要写在一行
        // 开发技巧：在做数据库开发是，如果遇到错误，可以先将SQL打印出来，拷贝到PC工具中验证之后再进行调试
        let sql = "CREATE TABLE IF NOT EXISTS T_Person( \n" +
        "id INTEGER PRIMARY KEY AUTOINCREMENT, \n" +
        "name TEXT, \n" +
        "age INTEGER \n" +
        "); \n"
        print(sql)
        
        // 执行SQL语句
        return execSQL(sql: sql)
    }
    
    /// 执行除查询以外的SQL语句
    func execSQL(sql:String) -> Bool {
        // 1、将swift字符串转为C语言字符串
        let cSQL = sql.cString(using: String.Encoding.utf8)
        
        // 在sqlite3中，除了查询以外（创建、删除、新增、更新）都是用同一个函数
        /*
         参数1：已经打开的数据库对象
         参数2：需要执行的SQL语句，C语言字符串
         参数3：执行SQL语句之后的回调，一般传nil
         参数4：是第三个参数的第一个参数，一般传nil
         参数5：错误信息，一般传nil
         */
        if sqlite3_exec(db, cSQL, nil, nil, nil) != SQLITE_OK {
            return false
        }
        return true
    }
    
    /// 查询所有的数据， 返回字典数组
    func execRecordSQL(sql:String) -> [[String:AnyObject]] {
        // 1、将swift字符串转为C语言字符串
        let cSQL = sql.cString(using: String.Encoding.utf8)
        
        // 准备：理解为预编译SQL语句，检测里面是否有错误等等，他可以提供性能
        /*
         参数1：已经打开的数据库对象
         参数2：需要执行的SQL语句，C语言字符串
         参数3：需要执行的SQL语句的长度，传入-1系统自动计算
         参数4：预编译之后的句柄，已经要想去除数据，就需要这个句柄
         参数5：错误信息，一般传nil
         */
        var stmt: OpaquePointer? = nil
        if sqlite3_prepare(db, cSQL, -1, &stmt, nil) != SQLITE_OK {
            print("准备失败")
        }
        
        // 准备成功
        var records = [[String: AnyObject]]()
        
        // 查询数据
        // sqlite3_step代表去除一条数据，如果去到了数据就会返回SQLITE_ROW
        while sqlite3_step(stmt) == SQLITE_ROW {
            // 获取一条记录的数据
            let record = recordWithStmt(stmt: stmt!)
            // 将当前获取到的这一条记录添加到数组
            records.append(record)
        }
        // 返回查询到的数据
        return records
    }
    
    /// 获取一条疾苦的值，返回字典
    private func recordWithStmt(stmt:OpaquePointer) -> [String:AnyObject] {
        // 拿到当前这条数据所有的列
        let count = sqlite3_column_count(stmt)
        
        // 定义字典存储查询到的数据
        var record = [String:AnyObject]()
        
        for index in 0..<count {
            // 拿到每一列的名称
            let cName = sqlite3_column_name(stmt, index)
            let name = String(cString: cName!, encoding: String.Encoding.utf8)
            
            // 拿到每一列的类型  SQLITE_INTERGER
            let type = sqlite3_column_type(stmt, index)
            
            switch type {
            case SQLITE_INTEGER:
                // 整形
                let num = sqlite3_column_int64(stmt, index)
                record[name!] = Int(num) as AnyObject
            case SQLITE_FLOAT:
                // 浮点型
                let double = sqlite3_column_double(stmt, index)
                record[name!] = Double(double) as AnyObject
            case SQLITE_TEXT:
                // 文本类型
                let cText = sqlite3_column_text(stmt, index)
                let text = String(cString: cText!)
                record[name!] = text as AnyObject
            case SQLITE_NULL:
                // 空类型
                record[name!] = NSNull()
                
            default:
                // 二进制类型 SQLITE_BLOB
                // 一般情况下，不会往数据库中存储二进制数据
                print("")
            }
            
        }
        return record
        
    }
    
}
