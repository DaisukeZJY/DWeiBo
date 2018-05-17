//
//  UIColor+Category.swift
//  DWeiBo
//
//  Created by DaiSuke on 2018/5/17.
//  Copyright © 2018年 DaiSuke. All rights reserved.
//

import Foundation


extension UIColor {
    
    // 生成随机颜色
    class func randomColor() ->UIColor{
        return UIColor(red: randomValue(), green: randomValue(), blue: randomValue(), alpha: 1.0)
    }
    
    /// 返回随机数
    private class func randomValue() -> CGFloat {
        return CGFloat(arc4random_uniform(256)/255)
    }
}
