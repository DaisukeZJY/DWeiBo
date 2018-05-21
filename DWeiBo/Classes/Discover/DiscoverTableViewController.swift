//
//  DiscoverTableViewController.swift
//  DWeiBo
//
//  Created by DaiSuke on 2016/10/27.
//  Copyright © 2016年 DaiSuke. All rights reserved.
//

import UIKit

class DiscoverTableViewController: BaseViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let attributed = NSMutableAttributedString()
        let str1 = NSAttributedString(string: "我")
        
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "preview_like_icon")
        // 修改附件尺寸
        attachment.bounds = CGRect(x: 0, y: -4, width: 20, height: 20)
        let imageText = NSAttributedString(attachment: attachment)
        
        let str2 = NSMutableAttributedString(string: "LOVE YOU")
        str2.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: NSMakeRange(5, 3))
        
        attributed.append(str1)
        attributed.append(imageText)
        attributed.append(str2)
        
        self.customLabel.attributedText = attributed
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // 初始化导航条
        setupNav()
        view.addSubview(textView)
        view.addSubview(customLabel)
        
        
        textView.xmg_AlignInner(type: XMG_AlignType.topCenter, referView: view, size: CGSize(width: UIScreen.main.bounds.width, height: 100), offset: CGPoint(x: 0, y: navHeight+100))
        customLabel.xmg_AlignVertical(type: XMG_AlignType.bottomLeft, referView: textView, size: CGSize(width: UIScreen.main.bounds.width, height: 100), offset: CGPoint(x: 0, y: 20))
        
        addChildViewController(emojiController)
        textView.inputView = emojiController.view
        
    }
    
//    lazy var textView = UITextView()
    lazy var textView: UITextView = {
        let view = UITextView()
        view.text = "shshasdaHAH双手合十"
        view.backgroundColor = UIColor.red
        return view
    }()
    
    // weak 相当于OC中的__weak,特点对象释放之后会将变量设置nil
    // unowned相当于OC中的unsafe_unretained ，特点对象释放之后不会将变量设置nil
    lazy var emojiController: EmoticonViewController = EmoticonViewController {
        [unowned self]
        (emoticon) in
        
//        self.textView.insertEmoticon(emoticon: emoticon, font: 20)
        
//        if emoticon.emoji != nil {
//            self.textView.replace(self.textView.selectedTextRange!, withText: emoticon.emoji!)
//        }
//
//        // 判断当前点击的是否是表情图片
//        if emoticon.png != nil {
//            // 创建附件
////            let attachment = NSTextAttachment()
//            let attachment = EmoticonTextAttachment()
//            attachment.chs = emoticon.chs
//            attachment.image = UIImage(contentsOfFile: emoticon.imagePath!)
//            // 设置附件大小
//            attachment.bounds = CGRect(x: 0, y: -4, width: 20, height: 20)
//
//            // 根据附件创建属性字符串
//            let imageText = NSAttributedString(attachment: attachment)
//
//            // 拿到当前所有内容
//            let strM = NSMutableAttributedString(attributedString: self.textView.attributedText)
//
//            // 插入表情到当前光标所在的位置
//            let range = self.textView.selectedRange
//            strM.replaceCharacters(in: range, with: imageText)
//
//            // 属性字符串有自己默认的尺寸
//            strM.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 19), range: NSMakeRange(range.location, 1))
//
//            // 将替换后的字符串赋值给textView
//            self.textView.attributedText = strM
//
//            // 恢复光标所在的位置
//            // 两个参数：第一个是指定光标所在的位置，第二个是选中文本的个数
//            self.textView.selectedRange = NSMakeRange(range.location+1, 0)
//
//        }
    }
    
    lazy var customLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    
    func setupNav() {
        navigationItem.leftBarButtonItem = UIBarButtonItem.createBarButtonItem("navigationbar_friendattention", target: self, action: #selector(leftItemClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem.createBarButtonItem("navigationbar_pop", target: self, action: #selector(rightItemClick))
        
    }
    
    func leftItemClick()
    {
        print(#function)
//        present(EmoticonViewController(), animated: true, completion: nil)
    }
    
    func rightItemClick()
    {
        print(#function)
        
        print(self.textView.emoticonAttributeText())
        
//        var strM = String()
//        // 后台需要发送给服务器的数据
//        self.textView.attributedText.enumerateAttributes(in: NSMakeRange(0, self.textView.attributedText.length), options: NSAttributedString.EnumerationOptions(rawValue: 0)) { (objc, range, _) in
//
//             // 遍历的时候传递给我们的objc是一个字典，如果字典中的NSAttachment这个可以有值，那么久证明当前是一个图片
//            print(objc["NSAttachment"] as Any)
//
//             // range就是春字符串的范围，如果春字符串中间有图片表情，那么range就会传递多次
//            print(range)
//            let les = (self.textView.text as NSString).substring(with: range)
//            print(les)
//
//            if objc["NSAttachment"] != nil {
//                // 图片
//                let attachment = objc["NSAttachment"] as! EmoticonTextAttachment
//                strM += attachment.chs!
//            } else {
//                // 文字
//                strM += (self.textView.text as NSString).substring(with: range)
//            }
//
//        }
//        print(strM)
//        // shshasdaHAH双手合十[馋嘴][馋嘴][馋嘴][馋嘴][馋嘴][馋嘴][馋嘴][可爱]
    }

}
