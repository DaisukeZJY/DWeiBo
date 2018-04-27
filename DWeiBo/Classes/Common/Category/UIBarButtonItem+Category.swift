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
}
