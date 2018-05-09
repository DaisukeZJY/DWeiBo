//
//  UILabel+Category.swift
//  DWeiBo
//
//  Created by DaiSuke on 2018/5/9.
//  Copyright © 2018年 DaiSuke. All rights reserved.
//

import Foundation


extension UILabel {
    
    /// 快速创建一个label
    class func createLabel(color:UIColor, fontSize:CGFloat) -> UILabel {
        let label = UILabel()
        label.textColor = color
        label.font = UIFont.systemFont(ofSize: fontSize)
        return label
    }
    
}
