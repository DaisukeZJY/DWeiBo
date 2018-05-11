//
//  StatusForwardTableViewCell.swift
//  DWeiBo
//
//  Created by DaiSuke on 2018/5/11.
//  Copyright © 2018年 DaiSuke. All rights reserved.
//

import UIKit

class StatusForwardTableViewCell: StatusTableViewCell {

    /*
     重写父类的属性的didSet并不会阀盖父类的操作
     只需要在重写方法中，做自己想做的事情即可
     注意点：如果父类是didSet，那么子类重写也只能重写didSet
     */
    override var status: Status? {
        didSet{
            let name = status?.retweeted_status?.user?.name ?? ""
            let text = status?.retweeted_status?.text ?? ""
            forwardLabel.text = name + ":" + text
            
        }
    }
    
    override func setupUI() {
        super.setupUI()
        
        // 添加子控件
        contentView.insertSubview(forwardButton, belowSubview: pictureView)
        contentView.insertSubview(forwardLabel, aboveSubview: forwardButton)
        
        // 布局
        forwardButton.xmg_AlignVertical(type: XMG_AlignType.bottomLeft, referView: contentLabel, size: nil, offset: CGPoint(x: -10, y: 10))
        forwardButton.xmg_AlignVertical(type: XMG_AlignType.topRight, referView: footerView, size: nil)
        
        forwardLabel.text = "上大号实打实大师"
        forwardLabel.xmg_AlignInner(type: XMG_AlignType.topLeft, referView: forwardButton, size: nil, offset: CGPoint(x: 10, y: 20))
        
        // 重新调整配图
        let cons = pictureView.xmg_AlignVertical(type: XMG_AlignType.bottomLeft, referView: forwardLabel, size: CGSize(width: 290, height: 290), offset: CGPoint(x: 0, y: 10))
        
        pictureWidthCons = pictureView.xmg_Constraint(cons, attribute: NSLayoutAttribute.width)
        pictureHeightCons = pictureView.xmg_Constraint(cons, attribute: NSLayoutAttribute.height)
        pictureTopCons = pictureView.xmg_Constraint(cons, attribute: NSLayoutAttribute.top)
    }
    
    
    private lazy var forwardLabel: UILabel = {
        let label = UILabel.createLabel(color: UIColor.darkGray, fontSize: 15)
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 20
        return label
    }()
    private lazy var forwardButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        return btn
    }()

}
