//
//  StatusTableViewCell.swift
//  DWeiBo
//
//  Created by DaiSuke on 2018/5/9.
//  Copyright © 2018年 DaiSuke. All rights reserved.
//

import UIKit
import SDWebImage

let kPictureViewCellId = "kPictureViewCellId"

/**
 保存cell的重用标志
 
 NormalCell：原创微博的重用标志
 ForwardCell：转发微博的重用标志
 */
enum StatusTableViewCellIdentifier:String {
    case NormalCell = "NormalCell"
    case ForwardCell = "ForwardCell"
    
    /*
     如果在枚举中利用static修饰一个方法，相当于类中的class修饰方法
     如果调用枚举值的rawValue，那么意味着拿到枚举对应的原始值
     */
    static func cellID(status:Status) ->String{
        return status.retweeted_status != nil ? ForwardCell.rawValue : NormalCell.rawValue
    }
}


class StatusTableViewCell: UITableViewCell {

    // 保存配图的宽度约束
    var pictureWidthCons:NSLayoutConstraint?
    // 保存配图的高度约束
    var pictureHeightCons:NSLayoutConstraint?
    // 保存配图的顶部约束
    var pictureTopCons:NSLayoutConstraint?
    
    var status:Status? {
        didSet{
            topView.status = status
            
//            contentLabel.text = status?.text
            contentLabel.attributedText = EmoticonPackage.emoticonRegex(str: status?.text ?? "")
            
            // 设置配图数据
            pictureView.status = status?.retweeted_status != nil ? status?.retweeted_status : status
            
            // 设置配图尺寸
            let size = pictureView.calculateImageSize()
            pictureWidthCons?.constant = size.width
            pictureHeightCons?.constant = size.height
            pictureTopCons?.constant = size.height == 0 ? 0 : 10
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 初始化UI
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.addSubview(topView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(footerView)
        contentView.addSubview(pictureView)
        
        // 布局
        
        let width = UIScreen.main.bounds.width
        topView.xmg_AlignInner(type: XMG_AlignType.topLeft, referView: contentView, size: CGSize(width: width, height: 60))
        
        contentLabel.xmg_AlignVertical(type: XMG_AlignType.bottomLeft, referView: topView, size: nil, offset: CGPoint(x: 10, y: 10))
        
        let cons = pictureView.xmg_AlignVertical(type: XMG_AlignType.bottomLeft, referView: contentLabel, size: CGSize.zero, offset: CGPoint(x: 0, y: 10))
        
        pictureWidthCons = pictureView.xmg_Constraint(cons, attribute: NSLayoutAttribute.width)
        pictureHeightCons = pictureView.xmg_Constraint(cons, attribute: NSLayoutAttribute.height)
        
        // 添加底部约束
        footerView.xmg_AlignVertical(type: XMG_AlignType.bottomLeft, referView: pictureView, size: CGSize(width: width, height: 44), offset: CGPoint(x: -10, y: 10))
    }
    
    /// 获取行高
    func rowHeight(status:Status) -> CGFloat {
        // 为了调用didSet， 计算配图的高度
        self.status = status
        // 强制更新页面
        self.layoutIfNeeded()
        
        // 返回底部试图最大的Y值
        return footerView.frame.maxY
    }
   
    
    private lazy var topView:StatusCellTopView = StatusCellTopView()
    
    // 正文
    lazy var contentLabel: UILabel = {
        let label = UILabel.createLabel(color: UIColor.darkGray, fontSize: 15)
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 20
        return label
    }()
    
    // 配图
    lazy var pictureView:StatusCellPictureView = StatusCellPictureView()

    // 底部工具条
    lazy var footerView: StatusCellBottomView = StatusCellBottomView()
    
}


