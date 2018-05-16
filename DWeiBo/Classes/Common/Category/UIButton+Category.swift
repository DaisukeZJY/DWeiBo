//
//  UIButton+Category.swift
//  DWeiBo
//
//  Created by DaiSuke on 2018/5/9.
//  Copyright © 2018年 DaiSuke. All rights reserved.
//

import Foundation

extension UIButton {
    /// 快速创建一个Button
    class func createButton(imageName: String, title: String) -> UIButton
    {
        let btn = UIButton()
        btn.setTitle(title, for: UIControlState.normal)
        btn.setImage(UIImage(named: imageName), for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        btn.setBackgroundImage(UIImage(named: "timeline_card_bottom_background"), for: UIControlState.normal)
        btn.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        return btn
    }
    
    convenience init(tittle:String, fontSize:CGFloat = 12, color: UIColor = UIColor.darkGray, backColor: UIColor = UIColor.white){
        self.init()
        setTitle(tittle, for: UIControlState.normal)
        setTitleColor(color, for: UIControlState.normal)
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        backgroundColor = backColor
    }
    
    convenience init(tittle:String, imageName:String, fontSize:CGFloat = 12, color: UIColor = UIColor.darkGray){
        self.init()
        setTitle(tittle, for: UIControlState.normal)
        setTitleColor(color, for: UIControlState.normal)
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        setImage(imageName: imageName)
    }
    
    convenience init(imageName:String){
        self.init()
        setImage(imageName: imageName)
    }
    
    func setImage(imageName:String) {
        setImage(UIImage(named: imageName), for: UIControlState.normal)
        // 提示：如果高亮图片不存在不会设置
        setImage(UIImage(named: imageName + "_highlighted"), for: UIControlState.highlighted)
    }
    
}
