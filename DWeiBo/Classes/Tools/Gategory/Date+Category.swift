//
//  Date+Category.swift
//  DWeiBo
//
//  Created by DaiSuke on 2018/5/10.
//  Copyright © 2018年 DaiSuke. All rights reserved.
//

import Foundation

extension NSDate {
    
    /// 字符串转date
    class func dateWithString(time:String) -> NSDate {
        // 创建fomatter
        let fomatter = DateFormatter()
        // 设置时间格式
        fomatter.dateFormat = "EEE MMM d HH:mm:ss Z yyyy"
        // 设置时间的区域（真机必须设置，否则可能转换不成功）
        fomatter.locale = Locale(identifier: "en")
        let createDate = fomatter.date(from: time)!
        return createDate as NSDate
    }
    
    
    /**
     刚刚(一分钟内)
     X分钟前(一小时内)
     X小时前(当天)
     昨天 HH:mm(昨天)
     MM-dd HH:mm(一年内)
     yyyy-MM-dd HH:mm(更早期)
     */
    var descDate:String {
        let calendar = NSCalendar.current
        
        // 判断是否今天
        if calendar.isDateInToday(self as Date) {
            // 获取当前时间和系统时间之间的差距
            let since = Int(NSDate().timeIntervalSince(self as Date))
            if since < 60 {
                return "刚刚"
            }
            if since < 60 * 60 {
                return "\(since/60)分钟前"
            }
            return "\(since/60/60)小时前"
        }
        
        // 判断是否是昨天
        var fomatterStr = "HH:mm"
        if calendar.isDateInYesterday(self as Date) {
            fomatterStr = "昨天:" + fomatterStr
        } else {
            // 处理一年以内
            fomatterStr = "MM-dd" + fomatterStr
            
            // 处理更早时间
            let comps = calendar.dateComponents([Calendar.Component.year], from: (self as Date), to: Date())
            if comps.year! >= 1 {
                fomatterStr = "yyyy-" + fomatterStr
            }
        }
        
        // 创建fomatter
        let fomatter = DateFormatter()
        fomatter.dateFormat = fomatterStr
        fomatter.locale = Locale(identifier: "en")
        return fomatter.string(from: self as Date)
    }
    
}

