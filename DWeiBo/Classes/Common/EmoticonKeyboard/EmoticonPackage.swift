//
//  EmoticonPackage.swift
//  DWeiBo
//
//  Created by DaiSuke on 2018/5/18.
//  Copyright © 2018年 DaiSuke. All rights reserved.
//

import UIKit

/*
 说明：
 1、Emoticons.bundle的根目录下存放emoticons.plist保存了packages表情包信息
    > package是一个数组，数组中存放的是字典
    > 字典中的属性id对应的分组路径的名称
 2、在id对应的目录下，各自都保存有info.plist
    > group_name_cn     保存的是分组名称
    > emoticons         保存的是表情信息数组
    > code              UNICODE编码字符串
    > chs               表情文字，发送给新浪微博服务器的文本内容
    > png               报请图片，在APP中进行图文混排使用的图片
 */

/// 表情包，存储每一组表情数据
class EmoticonPackage: NSObject {
    
    /// 表情路径
    var id:String?
    /// 分组名称
    var groupName:String?
    /// 表情数组
    var emoticons: [Emoticon]?
    
    init(id: String) {
        self.id = id
    }
    
    /// 加载表情包·数组·
    class func packages() -> [EmoticonPackage] {
        var list = [EmoticonPackage]()
        
        // 读取emoticons.plist文件
        let path = Bundle.main.path(forResource: "emoticons.plist", ofType: nil, inDirectory: "Emoticons.bundle")
        let dict = NSDictionary(contentsOfFile: path!)!
        let array = dict["packages"] as! [[String : AnyObject]]
        
        // 遍历数组
        for dic in array {
            // 创建表情包，并初始化对应的路径
            let package = EmoticonPackage(id: dic["id"] as! String)
            // 加载表情数组
            package.loadEmoticons()
            // 添加表情包
            list.append(package)
        }
        return list
    }
    
    /// 加载对应的表情数组
    private func loadEmoticons() {
        // 加载info.plist数据
        let dict = NSDictionary(contentsOfFile: plistPath())!
        // 设置分组名
        groupName = dict["group_name_cn"] as? String
        // 获取表情数组
        let array = dict["emoticons"] as! [[String : String]]
        
        // 实例化表情数组
        emoticons = [Emoticon]()
        // 遍历数组
        for dic in array {
            emoticons?.append(Emoticon(id:id!, dict: dic))
        }
    }
    
    /// 返回info.plist路径
    private func plistPath() -> String {
        return (EmoticonPackage.bundlePath().appendingPathComponent(id!) as NSString).appendingPathComponent("info.plist")
    }
    
    /// 返回表情包路径
    class func bundlePath() -> NSString {
        return (Bundle.main.bundlePath as NSString).appendingPathComponent("Emoticons.bundle") as NSString
    }
    
}

/// 表情模型
class Emoticon: NSObject {
    /// 表情路径
    var id:String?
    /// 表情文字，发送给新浪微博服务器的文本内容
    var chs:String?
    /// 表情图片，在APP中进行图文混排的图片
    var png:String?
    /// UNICODE编码字符串
    var code:String? {
        didSet{
            // 扫描器，可以扫描指定字符串中特定的文字
            let scanner = Scanner(string: code!)
            // 扫描整数
            var result: UInt32 = 0
            scanner.scanHexInt32(&result)
            // 生成字符串
            emoji = "\(Character(UnicodeScalar(result)!))"
        }
    }
    
    /// emoji字符串
    var emoji:String?
    
    /// 图片的完整路径
    var imagePath:String? {
        return png == nil ? nil : (EmoticonPackage.bundlePath().appendingPathComponent(id!) as NSString).appendingPathComponent(png!)
    }
    
    
    init(id:String, dict:[String : String]) {
        super.init()
        self.id = id
        // 使用KVC设置属性之前，必须调用super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}
