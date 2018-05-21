//
//  ComposeViewController.swift
//  DWeiBo
//
//  Created by DaiSuke on 2018/5/19.
//  Copyright © 2018年 DaiSuke. All rights reserved.
//

import UIKit
import SVProgressHUD

class ComposeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        // 添加子控制器
        addChildViewController(emoticonKeyboradVC)
        
        // 初始化导航栏
        setupNav()
        // 初始化输入框
        setupInputView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 主动唤起键盘
        textView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 隐藏键盘
        textView.resignFirstResponder()
    }
    
    
    private func setupNav() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.plain, target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: UIBarButtonItemStyle.plain, target: self, action: #selector(send))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        // 中间视图
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 32))
        let label = UILabel()
        label.text = "发送微博"
        label.font = UIFont.systemFont(ofSize: 15)
        label.sizeToFit()
        titleView.addSubview(label)
        
        let label1 = UILabel()
        label1.text = UserAccount.loadAccount()?.screen_name
        label1.font = UIFont.systemFont(ofSize: 15)
        label1.textColor = UIColor.darkGray
        label1.sizeToFit()
        titleView.addSubview(label1)
        
        label.xmg_AlignInner(type: XMG_AlignType.topCenter, referView: titleView, size: nil)
        label1.xmg_AlignInner(type: XMG_AlignType.bottomCenter, referView: titleView, size: nil)
        navigationItem.titleView = titleView
    }
    
    private func setupInputView() {
        view.addSubview(textView)
        textView.addSubview(placeholderLabel)
        
        // 布局子控件
        textView.xmg_Fill(view)
        placeholderLabel.xmg_AlignInner(type: XMG_AlignType.topLeft, referView: textView, size: nil, offset: CGPoint(x: 5, y: 8))
        
        // 设置输入视图辅助视图
        textView.inputAccessoryView = setupToolBar()
    }
    
    private func setupToolBar() -> UIToolbar {
        let tb = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 44))
        tb.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        let itemSettings = [["imageName": "compose_toolbar_picture", "action": "selectPicture"],
                            ["imageName": "compose_mentionbutton_background"],
                            ["imageName": "compose_trendbutton_background"],
                            ["imageName": "compose_emoticonbutton_background", "action": "inputEmoticon"],
                            ["imageName": "compose_addbutton_background"]]
        
        // 所有按钮的数组
        var items = [UIBarButtonItem]()
        // 设置按钮 - 问题：图片名称（高亮图片） / 监听方法
        for setting in itemSettings {
            items.append(UIBarButtonItem(imageName: setting["imageName"], highlightedImageName: nil, tagget: nil, actionName: setting["action"]))
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil))
        }
        // 删除末尾弹簧
        items.removeLast()
        tb.items = items
        return tb
    }
    
    
    func close() {
        dismiss(animated: true, completion: nil)
    }
    
    func send() {
        SVProgressHUD.show(withStatus: "正在发送。。。")
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        let path = "2/statuses/update.json"
        let params = ["access_token": UserAccount.loadAccount()?.access_token, "status":textView.text]
        NetworkTools.shareNetworkTools().post(path, parameters: params, progress: nil, success: { (_, json) in
            SVProgressHUD.dismiss()
            // 提示用户发送成功
            SVProgressHUD.showSuccess(withStatus: "发送成功")
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
            
            // 关闭页面
            self.close()
        }) { (_, error) in
            print(error)
            // 提示发送失败
            SVProgressHUD.showSuccess(withStatus: "发送失败")
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        }
    }
    
    /// 切换表情键盘
    func inputEmoticon() {
        // 如果输入视图是nul，说明使用的是系统键盘
        print(textView.inputView)
        
        // 要切换键盘之前，需要先关闭键盘
        textView.resignFirstResponder()
        
        // 更换键盘输入视图
        textView.inputView = (textView.inputView == nil) ? emoticonKeyboradVC.view : nil
        
        // 重新设置检点
        textView.becomeFirstResponder()
    }

    // MARK: - 懒加载
    lazy var textView: UITextView = {
        let view = UITextView()
        view.delegate = self
        view.font = UIFont.systemFont(ofSize: 13)
        // 设置垂直滚动
        view.alwaysBounceVertical = true
        // 滚动关闭键盘
        view.keyboardDismissMode = UIScrollViewKeyboardDismissMode.onDrag
        return view
    }()
    
    lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.darkGray
        label.text = "分享新鲜事..."
        return label
    }()
    
    /// 表情键盘
    lazy var emoticonKeyboradVC: EmoticonViewController = EmoticonViewController { [unowned self] (emoticon) in
        self.textView.insertEmoticon(emoticon: emoticon)
        self.textViewDidChange(self.textView)
    }

}

extension ComposeViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = textView.hasText
        navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
    }
}
