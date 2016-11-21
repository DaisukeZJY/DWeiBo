//
//  VisitorView.swift
//  DWeiBo
//
//  Created by DaiSuke on 2016/11/1.
//  Copyright © 2016年 DaiSuke. All rights reserved.
//

import UIKit

// Swift中如何定义协议：必须遵守NSObjectProtocol
protocol VisitorViewDelegate: NSObjectProtocol
{
    // 登录回调
    func loginBtnWillClick()
    
    // 注册回调
    func registerBtnWillClick()
}

class VisitorView: UIView {

    // 定义一个属性保存代理对象
    // 一定要加上weak，避免循环引用
    weak var delegate: VisitorViewDelegate?
    
    
    /// 设置未登录界面
    ///
    /// - parameter isHome:    是否是首页
    /// - parameter imageName: 需要展示的突变名称
    /// - parameter message:   展示的文本内容
    func setupVisitorInfo(_ isHome:Bool, imageName:String, message:String) {
        
        // 如果是首页，就隐藏转盘
        homeIcon.isHidden = !isHome
        
        // 修改中间图标
        homeIcon.image = UIImage(named: imageName)
        // 修改文本
        messageLabel.text = message
        
        // 判断是否执行动画
        if isHome {
            startAnimation()
        }
    }
    
    // MARK: 私有方法
    /// 开启动画
    fileprivate func startAnimation(){
        // 创建动画
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        // 设置动画属性
        anim.toValue = 2 * M_PI
        anim.duration = 20
        anim.repeatCount = MAXFLOAT
        
        // 该属性默认为yes，代表动画只要执行完毕就移除
        anim.isRemovedOnCompletion = false
        // 将动画添加到图层上
        iconView.layer.add(anim, forKey: nil)
        
    }
    
    
    // MARK - 懒加载控件
    // 转盘
    fileprivate lazy var iconView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
        return view
    }()
    
    // 图标
    fileprivate lazy var homeIcon: UIImageView = {
       let view = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
        return view
    }()
    
    
    // 文本
    fileprivate lazy var messageLabel: UILabel = {
       let lebel = UILabel()
        lebel.numberOfLines = 0
        lebel.textColor = UIColor.black
        lebel.text = "这是文本这是文本这是文本这是文本这是文本这是文本这是文本"
        return lebel;
    }()
    
    // 登录按钮
    fileprivate lazy var loginBtn: UIButton = {
        let loginBtn = UIButton()
        loginBtn.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        loginBtn.setTitle("登录", for: UIControlState.normal)
        loginBtn.setBackgroundImage(UIImage(named: "common_button_white_disable"), for: UIControlState.normal)
        loginBtn.addTarget(self, action: #selector(VisitorView.loginBtnClick), for: UIControlEvents.touchUpInside)
        return loginBtn
    }()
    
    
    // 注册按钮
    fileprivate lazy var registerBtn: UIButton = {
        let registerBtn = UIButton()
        registerBtn.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        registerBtn.setTitle("注册", for: UIControlState.normal)
        registerBtn.setBackgroundImage(UIImage(named: "common_button_white_disable"), for: UIControlState.normal)
        registerBtn.addTarget(self, action: #selector(VisitorView.registerBtnClick), for: UIControlEvents.touchUpInside)
        return registerBtn
    }()
    
    
    
    /// 点击登录按钮
    func loginBtnClick(){
        print(#function)
        delegate?.loginBtnWillClick()
    }
    
    
    /// 点击注册按钮
    func registerBtnClick(){
        print(#function)
        delegate?.registerBtnWillClick()
    }
    
    
    
    
    
    

}
