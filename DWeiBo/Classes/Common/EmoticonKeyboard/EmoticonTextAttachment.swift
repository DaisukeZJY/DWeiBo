//
//  EmoticonTextAttachment.swift
//  DWeiBo
//
//  Created by DaiSuke on 2018/5/19.
//  Copyright © 2018年 DaiSuke. All rights reserved.
//

import UIKit

class EmoticonTextAttachment: NSTextAttachment {

    /// 保存对应表情的文字
    var chs:String?
    
    class func imageText(emoticon:Emoticon, font:UIFont) -> NSAttributedString {
        // 创建附件
        let attachment = EmoticonTextAttachment()
        attachment.chs = emoticon.chs
        attachment.image = UIImage(contentsOfFile: emoticon.imagePath!)
        // 设置附件大小
        let s = font.lineHeight
        attachment.bounds = CGRect(x: 0, y: -4, width: s, height: s)
        // 根据附件创建属性字符串
        let imageText = NSAttributedString(attachment: attachment)
        // 获得现在的属性文本
        let strM = NSMutableAttributedString(attributedString: imageText)
        // 设置表情图片的字体
        strM.addAttribute(NSFontAttributeName, value: font, range: NSMakeRange(0, 1))
        return strM
    }
}
