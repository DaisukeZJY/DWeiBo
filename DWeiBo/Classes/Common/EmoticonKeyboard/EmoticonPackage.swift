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
    
    static let packageList: [EmoticonPackage] = EmoticonPackage.packages()
    class func emoticonRegex(str:String) ->NSAttributedString?{
        let strM = NSMutableAttributedString(string: str)
        
        do {
            // 创建规则
            let pattern = "\\[.*?\\]"
            // 创建正则对象
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options(rawValue: 0))
            // 开始匹配
            let array = regex.matches(in: str, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, str.count))
            // 遍历结果数组
            var count = array.count
            while count > 0 {
                // 拿到匹配结果
                count -= 1
                let res = array[count]
                // 拿到range
                let range = res.range
                // 拿到匹配的字符串
                let tempStr = (str as NSString).substring(with: range)
                // 查找模型
                if let emoticon = emotcionWithStr(str: tempStr){
                    // 生成属性字符串
                    let attstr = EmoticonTextAttachment.imageText(emoticon: emoticon, font: UIFont.systemFont(ofSize: 17))
                    // 替换表情
                    strM.replaceCharacters(in: range, with: attstr)
                }
            }
            return strM
        } catch  {
            print(error)
            return nil
        }
    }
    
    /// 根据指定字符串获得表情模型
    class func emotcionWithStr(str:String) -> Emoticon? {
        var emoticon:Emoticon?
        for package in EmoticonPackage.packageList {
            emoticon = package.emoticons?.filter({ (emo) -> Bool in
                return emo.chs == str
            }).last
            if emoticon != nil {
                break
            }
        }
        return emoticon
    }
    
    /// 加载表情包·数组·
    class func packages() -> [EmoticonPackage] {
        var list = [EmoticonPackage]()
        
        // 设置最近的表情包
        let pa = EmoticonPackage(id: "")
        pa.groupName = "最近"
        pa.emoticons = [Emoticon]()
        // 追加表情
        pa.appendEmptyEmoticons()
        list.append(pa)
        
        
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
            // 追加空白模型
            package.appendEmptyEmoticons()
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
        var index = 0
        for dic in array {
            if index == 20 {
                // 插入删除按钮
                emoticons?.append(Emoticon(isRemoveBtn: true))
                index = 0
            }
            
            emoticons?.append(Emoticon(id:id!, dict: dic))
            index += 1
        }
    }
    
    /// 追加空白按钮，方便界面布局，如果一个界面的图标不足20个，补足，最后添加一个删除按钮
    private func appendEmptyEmoticons() {
        if emoticons == nil {
            emoticons = [Emoticon]()
        }
        let count = emoticons!.count % 21
        if count > 0 || emoticons!.count == 0 {
            for _ in count..<20 {
                // 追加空白按钮
                emoticons?.append(Emoticon(isRemoveBtn: false))
            }
            // 追加一个删除按钮
            emoticons?.append(Emoticon(isRemoveBtn: true))
        }
    }
    
    /// 用于添加最近表情
    func appendEmoticons(emoticon: Emoticon) {
        // 判断是否是删除按钮
        if emoticon.removeBtn {
            return
        }
        
        // 判断当前点击的表情是否已经添加到最近数组中
        let contains = emoticons!.contains(emoticon)
        if !contains {
            // 删除删除按钮
            emoticons?.removeLast()
            emoticons?.append(emoticon)
        }
        
        // 对数组进行排序
        var result = emoticons?.sorted(by: { (e1, e2) -> Bool in
            return e1.times > e2.times
        })
        
        // 删除多余的表情
        if !contains {
            result?.removeLast()
            result?.append(Emoticon(isRemoveBtn: true))
        }
        
        emoticons = result
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
    
    /// 是否删除按钮的标记
    var removeBtn = false
    
    /// 记录当前表情被使用次数
    var times:Int = 0
    
    init(isRemoveBtn:Bool) {
        super.init()
        self.removeBtn = isRemoveBtn
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
