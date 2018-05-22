//
//  UITextView+Category.swift
//  DWeiBo
//
//  Created by DaiSuke on 2018/5/19.
//  Copyright © 2018年 DaiSuke. All rights reserved.
//

import Foundation


extension UITextView {
    /// 插入表情
    func insertEmoticon(emoticon:Emoticon) {
        // 处理删除按钮
        if emoticon.removeBtn {
            deleteBackward()
        }
        
        // 判断当前点击是否是emoji表情
        if emoticon.emoji != nil {
            self.replace(self.selectedTextRange!, withText: emoticon.emoji!)
        }
        
        // 判断当前点击的是否是表情图片
        if emoticon.png != nil {
            
            // 根据附件创建属性字符串
            let imageText = EmoticonTextAttachment.imageText(emoticon: emoticon, font: font!)
            
            // 拿到当前所有内容
            let strM = NSMutableAttributedString(attributedString: self.attributedText)
            
            // 插入表情到当前光标所在的位置
            let range = self.selectedRange
            strM.replaceCharacters(in: range, with: imageText)
            
            // 将替换后的字符串赋值给textView
            self.attributedText = strM
            
            // 恢复光标所在的位置
            // 两个参数：第一个是指定光标所在的位置，第二个是选中文本的个数
            self.selectedRange = NSMakeRange(range.location+1, 0)
            
        }
    }
    
    func emoticonAttributeText() -> String {
        var strM = String()
        // 后台需要发送给服务器的数据
        attributedText.enumerateAttributes(in: NSMakeRange(0, attributedText.length), options: NSAttributedString.EnumerationOptions(rawValue: 0)) { (objc, range, _) in
            
            // 遍历的时候传递给我们的objc是一个字典，如果字典中的NSAttachment这个可以有值，那么久证明当前是一个图片
            
            // range就是春字符串的范围，如果春字符串中间有图片表情，那么range就会传递多次
            
            if objc["NSAttachment"] != nil {
                // 图片
                let attachment = objc["NSAttachment"] as! EmoticonTextAttachment
                strM += attachment.chs!
            } else {
                // 文字
                strM += (self.text as NSString).substring(with: range)
            }
            
        }
        return strM
    }
}
