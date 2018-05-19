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
    
    class func imageText(emoticon:Emoticon, font:CGFloat) -> NSAttributedString {
        // 创建附件
        let attachment = EmoticonTextAttachment()
        attachment.chs = emoticon.chs
        attachment.image = UIImage(contentsOfFile: emoticon.imagePath!)
        // 设置附件大小
        attachment.bounds = CGRect(x: 0, y: -4, width: font, height: font)
        // 根据附件创建属性字符串
        return NSAttributedString(attachment: attachment)
    }
}
