//
//  ViewController.swift
//  DWeiBo
//
//  Created by DaiSuke on 2016/10/27.
//  Copyright © 2016年 DaiSuke. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        let start = CFAbsoluteTimeGetCurrent()
//
//        for i in 0..<10000{
//            let person = TestPerson(dict: ["name":"daisuke" as AnyObject, "age":(2+i as AnyObject)])
//            person.insertPerson()
//        }
//
//        print("耗时：\(CFAbsoluteTimeGetCurrent() - start)")
//        // 耗时：14.7124910354614
        
        
//        let start = CFAbsoluteTimeGetCurrent()
//
//        let manager = SQLiteManager.share()
//        // 开启事务
//        manager.beginTransaction()
//
//        for i in 0..<10000{
//            let person = TestPerson(dict: ["name":"daisuke" as AnyObject, "age":(2+i as AnyObject)])
//            person.insertQueuePerson()
//            if i == 1000 {
//                manager.rollbackTransaction()
//                // 注意点：回滚之后一定要跳出循环停止更新
//                return
//            }
//        }
//
//        // 提交事务
//        manager.commitTransaction()
//
//        print("耗时：\(CFAbsoluteTimeGetCurrent() - start)")
        // 耗时：0.696339964866638
        
        
        
        let start = CFAbsoluteTimeGetCurrent()
        
        let manager = SQLiteManager.share()
        // 开启事务
        manager.beginTransaction()
        
        for i in 0..<10000{
            let sql = "INSERT INTO T_Person (name, age) VALUES (?, ?);"
            manager.batchExecSQL(sql: sql, args: "yy + \(i)", 1+i)
        }
        
        // 提交事务
        manager.commitTransaction()
        
        print("耗时：\(CFAbsoluteTimeGetCurrent() - start)")
        
        
        
        
        
        
        
        
//        view.addSubview(customLabel)
//        customLabel.xmg_AlignInner(type: XMG_AlignType.topLeft, referView: view, size: CGSize(width: UIScreen.main.bounds.width, height: 200), offset: CGPoint(x: 0, y: 200))
//
//
//
//        customLabel.text = "这是我的博客地址：http://daisuke.cn 欢迎来这里看看，记住是这里：http://daisuke.cn"
        
        
        // Do any additional setup after loading the view, typically from a nib.
//        let str = "@jack12:【动物尖叫合辑】#肥猪流#猫头鹰这么尖叫[偷笑]、@南哥: 老鼠这么尖叫、兔子这么尖叫[吃惊]、@花满楼: 莫名奇#小笼包#妙的笑到最后[挖鼻屎]！~ http://t.cn/zYBuKZ8"
//        urlRegex(str: str) // http://t.cn/zYBuKZ8
//        contentRegex(str: str)
        /*
         @jack12:
         #肥猪流#
         [偷笑]
         @南哥:
         [吃惊]
         @花满楼:
         #小笼包#
         [挖鼻屎]
         http://t.cn/zYBuKZ8
         */
        
//        emoticonRegex(str: "我[爱你]好久了[好爱哦]")
//        EmoticonPackage
    }
    
    func urlRegex(str:String) {
        do {
            // 创建匹配对象
            /*
             NSDataDetector：是NSRegularExpression的子类，里面能够匹配URL,电话,日期,地址
             */
            let dataDetector = try NSDataDetector(types: NSTextCheckingTypes(NSTextCheckingResult.CheckingType.link.rawValue))
            
            // 匹配所有的URL
            let array = dataDetector.matches(in: str, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, str.count))
            if array.count > 0 {
                for checking in array {
                    print((str as NSString).substring(with: checking.range))
                }
            }
            
        } catch  {
            print(error)
        }
    }
    
    func contentRegex(str:String) {
        do {
            /*
             - . 匹配任意字符，除了换行
             - * 匹配任意长度的内容
             - ? 尽量少的匹配
             */
            // 1.创建规则
            // 1.1表情规则
            let emoticonPattern = "\\[.*?\\]"
            // 1.2用户名规则
            let atPattern = "@.*?:"
            // 1.3话题规则
            let topicPattern = "#.*?#"
            // 1.4url规则
            let urlPattern = "http(s)?://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?"
            let pattern = emoticonPattern + "|" + atPattern + "|" + topicPattern + "|" + urlPattern
            
            // 创建正则表达式对象
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options(rawValue: 0))
            // 开始匹配
            let array = regex.matches(in: str, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, str.count))
            if array.count > 0 {
                for checking in array {
                    print((str as NSString).substring(with: checking.range))
                }
            }
            
        } catch  {
            print(error)
        }
    }
    
    
//    func emoticonRegex(str:String) {
//        var strM = NSMutableAttributedString(string: str)
//
//        do {
//            // 创建规则
//            let pattern = "\\[.*?\\]"
//            // 创建正则对象
//            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options(rawValue: 0))
//            // 开始匹配
//            let array = regex.matches(in: str, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, str.count))
//            // 遍历结果数组
//            var count = array.count
//            while count > 0 {
//                // 拿到匹配结果
//                count -= 1
//                let res = array[count]
//                // 拿到range
//                let range = res.range
//                // 拿到匹配的字符串
//                let tempStr = (str as NSString).substring(with: range)
//                // 查找模型
//                if let emoticon = emotcionWithStr(str: tempStr){
//                    // 生成属性字符串
//                    let attstr = EmoticonTextAttachment.imageText(emoticon: emoticon, font: UIFont.systemFont(ofSize: 17))
//                    // 替换表情
//                    strM.replaceCharacters(in: range, with: attstr)
//                }
//                print(strM)
//                self.customLabel.attributedText = strM
//            }
//
//        } catch  {
//            print(error)
//        }
//
//    }
//
//    /// 根据指定字符串获得表情模型
//    func emotcionWithStr(str:String) -> Emoticon? {
//        var emoticon:Emoticon?
//        for package in EmoticonPackage.packages() {
//            emoticon = package.emoticons?.filter({ (emo) -> Bool in
//                return emo.chs == str
//            }).last
//            if emoticon != nil {
//                break
//            }
//        }
//        return emoticon
//    }
    
    
    func test() {
        let string = "123123s1728a19"
        
        do {
            let pattern = "[1-9][0-9]{4,14}"
            // 创建正则表达式对象
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            
            // 开始匹配
            // 返回正确匹配的个数
            
            let number = regex.numberOfMatches(in: string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, string.count))
            if number == 0 {
                return
            }
            print("匹配个数：\(number)")
            
            
            // 返回第一个匹配的结果
            if let res = regex.firstMatch(in: string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, string.count)) {
                print((string as NSString).substring(with: res.range))
            } else {
                return
            }
            
            // 返回第一个正确匹配结果字符串的NSRange
            let res = regex.rangeOfFirstMatch(in: string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, string.count))
            print((string as NSString).substring(with: res))
            
            // 返回所有匹配结果的集合（适合从一段字符串中提取我们想要匹配的所有数据）
            let array = regex.matches(in: string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, string.count))
            for res in array {
                print((string as NSString).substring(with: res.range))
            }
            
            /*
             执行每一个结果集
             result：匹配结果
             matchingFlag：匹配状态
             pointer：执行停止控制
             */
            regex.enumerateMatches(in: string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, string.count)) { (result, matchingFlag, pointer) in
                print((string as NSString).substring(with: (result?.range)!))
                print(matchingFlag)
                print(pointer)
            }
            
            
        } catch  {
            print(error)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    lazy var customLabel: DDLabel = {
        let label = DDLabel()
        label.backgroundColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()

}

