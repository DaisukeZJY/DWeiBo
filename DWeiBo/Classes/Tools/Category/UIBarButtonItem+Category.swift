//
//  UIBarButtonItem+Category.swift
//  DWeiBo
//
//  Created by DaiSuke on 2018/4/27.
//  Copyright © 2018年 DaiSuke. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    // 声明一个类型方法，类方法使用class关键字
    class func createBarButtonItem(_ imageName:String, target:AnyObject?, action:Selector) -> UIBarButtonItem {
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), for: UIControlState.normal)
        btn.setImage(UIImage(named: imageName), for: UIControlState.highlighted)
        btn.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
        btn.sizeToFit()
        return UIBarButtonItem(customView: btn)
    }
    
    convenience init(imageName:String?, highlightedImageName:String?, tagget:AnyObject?, actionName:String?) {
        
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName!), for: UIControlState.normal)
        let highName = highlightedImageName ?? imageName! + "_highlighted"
        btn.setImage(UIImage(named: highName), for: UIControlState.highlighted)
        btn.sizeToFit()
        // 添加监听方法
        if actionName != nil {
            btn.addTarget(tagget, action: Selector(actionName!), for: UIControlEvents.touchUpInside)
        }
        self.init(customView: btn)
    }
}
