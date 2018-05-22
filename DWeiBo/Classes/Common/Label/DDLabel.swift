//
//  DDLabel.swift
//  DWeiBo
//
//  Created by DaiSuke on 2018/5/22.
//  Copyright © 2018年 DaiSuke. All rights reserved.
//

import UIKit

class DDLabel: UILabel {
    
    override var text: String?{
        didSet{
            // 1、修改textStorage存储的内容
            textStorage.setAttributedString(NSAttributedString(string: text!))
            
            // 2、设置textStorage的属性
            textStorage.addAttribute(NSFontAttributeName, value: font, range: NSMakeRange(0, text!.count))
            
            // 处理URL
            self.URLRegex()
            
            // 通知layoutManager重新布局
            setNeedsDisplay()
        }
    }

    /// 如果UILabel调用setNeedsDisplay方法，系统会触发drawText方法
    override func drawText(in rect: CGRect) {
        /*
         重绘字形，理解为一个小的UIView
         
         forGlyphRange: 指定绘制的范围
         at：指定从什么位置开始绘制
         */
        layoutManager.drawGlyphs(forGlyphRange: NSMakeRange(0, text!.count), at: CGPoint.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSystem()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSystem()
    }
    
    private func setupSystem() {
        // 1、将layoutManager添加到textStorage中
        textStorage.addLayoutManager(layoutManager)
        
        // 2、将textContainer添加到layoutManager
        layoutManager.addTextContainer(textContainer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 3、指定区域
        textContainer.size = bounds.size
    }
    
    // MARK: - 懒加载
    /*
     只要textStorage中的内容发生变化，就可以通知layoutManager重新布局
     layoutManager重新布局需要知道绘制到什么地方，所以layoutManager就会找textContainer绘制的区域
     */
    
    // 专门用于存储内容的。textStorage 中有 layoutManager
    private lazy var textStorage = NSTextStorage()
    
    // 专门用于管理布局的。layoutManager 中有 textContainer
    private lazy var layoutManager = NSLayoutManager()
    
    // 专门用于指定绘制的区域
    private lazy var textContainer = NSTextContainer()
    
    /// 匹配URL
    func URLRegex() {
        do {
            // 创建正则表达式对象
            let dataDerector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            // 匹配
            let resArray = dataDerector.matches(in: textStorage.string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, textStorage.string.count))
            
            // 取出结果
            for checkingRes in resArray {
                let str = (textStorage.string as NSString).substring(with: checkingRes.range)
                let tempStr = NSMutableAttributedString(string: str)
                
                // 设置属性
                tempStr.addAttributes([NSFontAttributeName : font!, NSForegroundColorAttributeName : UIColor.red], range: NSMakeRange(0, str.count))
                
                textStorage.replaceCharacters(in: checkingRes.range, with: tempStr)
            }
        } catch  {
            print(error)
        }
    }
    
}
