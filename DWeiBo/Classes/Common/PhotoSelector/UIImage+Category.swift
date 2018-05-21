//
//  UIImage+Category.swift
//  DWeiBo
//
//  Created by DaiSuke on 2018/5/21.
//  Copyright © 2018年 DaiSuke. All rights reserved.
//

import Foundation

extension UIImage {
    
    /// 将图片缩放到指定宽度
    func scaleImageToWidth(width:CGFloat) -> UIImage {
        // 提示：不要使用比例，如果所有照片都按照指定比例来缩放，图片太小就看不见了
        // 判断宽度，如果小于指定宽度直接返回对象
        if size.width < width {
            return self
        }
        
        // 计算等比例缩放的高度
        let height = width * size.height / size.width
        
        // 图像的上下文
        let sizeContext = CGSize(width: width, height: height)
        UIGraphicsBeginImageContext(sizeContext)
        // 在指定区域中缩放绘制完整图像
        draw(in: CGRect(origin: CGPoint.zero, size: sizeContext))
        // 获取绘制结果
        let result = UIGraphicsGetImageFromCurrentImageContext()
        // 关闭上下文
        UIGraphicsEndImageContext()
        return result!
    }
}
