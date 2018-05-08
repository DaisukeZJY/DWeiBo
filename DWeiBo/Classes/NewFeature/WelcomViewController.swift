//
//  WelcomViewController.swift
//  DWeiBo
//
//  Created by DaiSuke on 2018/5/8.
//  Copyright © 2018年 DaiSuke. All rights reserved.
//

import UIKit
import SDWebImage

class WelcomViewController: UIViewController {

    var bottomConstaint:NSLayoutConstraint?
    
    // 初始化页面
    private func setupUI() {
        view.addSubview(bgImageView)
        view.addSubview(iconView)
        view.addSubview(message)
        
        // 布局
        bgImageView.xmg_Fill(view)
        let cons = iconView.xmg_AlignInner(type: XMG_AlignType.bottomCenter, referView: view, size: CGSize(width: 100, height: 100), offset: CGPoint(x: 0, y: -200))
        // 记录底部约束
        bottomConstaint = iconView.xmg_Constraint(cons, attribute: NSLayoutAttribute.bottom)
        
        // 约束文字
        message.xmg_AlignVertical(type: XMG_AlignType.bottomCenter, referView: view, size: nil, offset: CGPoint(x: 0, y: -54))
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 初始化子控件
        setupUI()
        
        // 设置用户信息
        if let iconUrl = UserAccount.loadAccount()?.avatar_large {
            iconView.sd_setImage(with: NSURL(string: iconUrl)! as URL)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 提示：修改约束不会立即生效，添加了一个标记，统一由自动布局系统更新约束
        bottomConstaint?.constant = -UIScreen.main.bounds.height - bottomConstaint!.constant
        print(-UIScreen.main.bounds.height)
        print(bottomConstaint!.constant)
        
        UIView.animate(withDuration: 1.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: {
            // 强制更新约束
            self.view.layoutIfNeeded()
        }) { (finish) in
            UIView.animate(withDuration: 1.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: {
                self.message.alpha = 1.0
            }) { (finish) in
                print("OK")
                NotificationCenter.default.post(name: Notification.Name(rawValue: kSwitchRootViewControllerKey), object: true)
            }
        }
    }
    

    // MARK: - 懒加载
    private lazy var bgImageView: UIImageView = UIImageView(image: UIImage(named: "ad_background"))
    private lazy var iconView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "avatar_default_big"))
        view.layer.cornerRadius = 50
        view.layer.masksToBounds = true
        return view
    }()
    private lazy var message: UILabel = {
        let label = UILabel()
        label.text = "欢迎归来"
        label.alpha = 0.0
        label.sizeToFit()
        return label
    }()
}
