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

    /// 工具栏底部约束
    private var toolbarBottomCons:NSLayoutConstraint?
    /// 图片选择器高度约束
    private var photoViewHeightCons:NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        // 添加子控制器
        addChildViewController(emoticonKeyboradVC)
        addChildViewController(photoSelectorVC)
        
        // 初始化导航栏
        setupNav()
        
        // 初始化输入框
        setupInputView()
        
        // 初始化图片选择器
        setupPhotoView()
        
        // 初始化工具条
        setupToolBar()
        
        // 注册通知监听键盘
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChange(notify:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
    }
    
    deinit {
        // 注销通知
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if photoViewHeightCons?.constant == 0 {
            // 主动唤起键盘
            textView.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 隐藏键盘
        textView.resignFirstResponder()
    }
    
    // MARK: - 初始化方法
    
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
        textView.alwaysBounceVertical = true
        textView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.onDrag
        
        // 布局子控件
        textView.xmg_Fill(view)
        placeholderLabel.xmg_AlignInner(type: XMG_AlignType.topLeft, referView: textView, size: nil, offset: CGPoint(x: 5, y: 8))
        
        // 设置输入视图辅助视图
//        textView.inputAccessoryView = setupToolBar()
    }
    
    private func setupPhotoView(){
        view.insertSubview(photoSelectorVC.view, belowSubview: toolbar)
        
        // 布局
        let size = UIScreen.main.bounds.size
        let width = size.width
        let height:CGFloat = 0
        let cons = photoSelectorVC.view.xmg_AlignInner(type: XMG_AlignType.bottomLeft, referView: view, size: CGSize(width: width, height: height))
        photoViewHeightCons = photoSelectorVC.view.xmg_Constraint(cons, attribute: NSLayoutAttribute.height)
        
    }
    
    private func setupToolBar() {
        view.addSubview(toolbar)
        view.addSubview(tipLabel)
        
//        let tb = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 44))
//        tb.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
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
        toolbar.items = items
        
        // 布局toolbar
        let width = UIScreen.main.bounds.width
        let cons = toolbar.xmg_AlignInner(type: XMG_AlignType.bottomLeft, referView: view, size: CGSize(width: width, height: 44))
        toolbarBottomCons = toolbar.xmg_Constraint(cons, attribute: NSLayoutAttribute.bottom)
        
        tipLabel.xmg_AlignVertical(type: XMG_AlignType.topRight, referView: toolbar, size: nil, offset: CGPoint(x: -10, y: -10))
        
    }
    
    func keyboardChange(notify: Notification) {
        // 获取最终的frame - oc中将结构体保存在字典中，存成NSValue
        let value = notify.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        let rect = value.cgRectValue
        
        let height = UIScreen.main.bounds.height
        toolbarBottomCons?.constant = -(height - rect.origin.y)
        
        // 更新页面
        let duration = notify.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        
        /*
         工具条回弹是因为执行了两次动画，而系统自带的键盘的动画节奏（曲线） 7
         7 在Apple API中并没有提供我们，但是我们可以用7 这种节奏的特点
         ：如果连续执行两次动画，不管上一次有没有执行完毕，都会立刻执行下一次，也就是说上一次可能会被忽略
         
         如果将动画节奏设置为7，那么动画的时长无论如何都会自动修改为0.5
         UIView动画的本质是核心动画，所以可以给核心动画设置动画节奏
         */
        
        // 取出键盘的动画节奏
        let curve = notify.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber
        
        UIView.animate(withDuration: duration.doubleValue) {
            // 设置动画节奏
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: curve.intValue)!)
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - 导航栏按钮事件
    
    func close() {
        dismiss(animated: true, completion: nil)
    }
    
    func send() {
        let text = textView.emoticonAttributeText()
        let image = photoSelectorVC.photos.first
        
        SVProgressHUD.show(withStatus: "正在发送。。。")
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        NetworkTools.shareNetworkTools().sendStatus(text: text, image: image, successCallBack: { (status) in
            // 提示用户发送成功
            SVProgressHUD.showSuccess(withStatus: "发送成功")
        }) { (error) in
            print(error)
            SVProgressHUD.showError(withStatus: "发送失败")
        }
    }
    
    // MARK: - 工具条事件
    
    /// 切换图片选择器
    func selectPicture() {
        // 关闭键盘
        textView.resignFirstResponder()
        
        // 调整图片选择器的高度
        photoViewHeightCons?.constant = UIScreen.main.bounds.height * 0.6
    }
    
    /// 切换表情键盘
    func inputEmoticon() {
        // 如果输入视图是nul，说明使用的是系统键盘
//        print(textView.inputView)
        
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
    
    lazy var toolbar:UIToolbar = UIToolbar()
    
    lazy var tipLabel: UILabel = UILabel()
    
    /// 表情键盘
    private lazy var emoticonKeyboradVC: EmoticonViewController = EmoticonViewController { [unowned self] (emoticon) in
        self.textView.insertEmoticon(emoticon: emoticon)
        self.textViewDidChange(self.textView)
    }
    
    /// 图片选择器
    private lazy var photoSelectorVC:PhotoSelectorController = PhotoSelectorController()

}

private let maxTipLength = 10
extension ComposeViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = textView.hasText
        navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
        
        // 当已经输入的内容长度
        let count = textView.emoticonAttributeText().count
        let res = maxTipLength - count
        tipLabel.textColor = (res > 0) ? UIColor.darkGray : UIColor.red
        tipLabel.text = res == maxTipLength ? "" : "\(res)"
    }
}
