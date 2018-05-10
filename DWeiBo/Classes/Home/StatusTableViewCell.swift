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

class StatusTableViewCell: UITableViewCell {

    // 保存配图的宽度约束
    var pictureWidthCons:NSLayoutConstraint?
    // 保存配图的高度约束
    var pictureHeightCons:NSLayoutConstraint?
    
    var status:Status? {
        didSet{
            nameLabel.text = status?.user?.name
            timeLabel.text = status?.created_at
            sourceLabel.text = status?.source
            contentLabel.text = status?.text
            if let url = status?.user?.profile_image_url {
                iconView.sd_setImage(with: URL(string: url))
            }
            
            // 设置会员图标
            verifiedView.image = status?.user?.verifiedImage
            vipView.image = status?.user?.mbrankImage
            
            // 设置配图尺寸
            let size = calculateImageSize()
            pictureWidthCons?.constant = size.viewSize.width
            pictureHeightCons?.constant = size.viewSize.height
            pictureLayout.itemSize = size.itemSize
            pictureView.reloadData()
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 初始化UI
        setupUI()
        
        // 初始化配图
        setupPictureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(iconView)
        contentView.addSubview(verifiedView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(vipView)
        contentView.addSubview(timeLabel)
        contentView.addSubview(sourceLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(footerView)
        contentView.addSubview(pictureView)
        
        // 布局
        iconView.xmg_AlignInner(type: XMG_AlignType.topLeft, referView: contentView, size: CGSize(width: 50, height: 50), offset: CGPoint(x: 10, y: 10))
        verifiedView.xmg_AlignInner(type: XMG_AlignType.bottomRight, referView: iconView, size: CGSize(width: 14, height: 14), offset: CGPoint(x: 5, y: 5))
        nameLabel.xmg_AlignHorizontal(type: XMG_AlignType.topRight, referView: iconView, size: nil, offset: CGPoint(x: 10, y: 0))
        vipView.xmg_AlignHorizontal(type: XMG_AlignType.topRight, referView: nameLabel, size: nil, offset: CGPoint(x: 10, y: 0))
        timeLabel.xmg_AlignHorizontal(type: XMG_AlignType.bottomRight, referView: iconView, size: nil, offset: CGPoint(x: 10, y: 0))
        sourceLabel.xmg_AlignHorizontal(type: XMG_AlignType.bottomRight, referView: timeLabel, size: nil, offset: CGPoint(x: 10, y: 0))
        contentLabel.xmg_AlignVertical(type: XMG_AlignType.bottomLeft, referView: iconView, size: nil, offset: CGPoint(x: 0, y: 10))
        
        // 配图约束
        let cons = pictureView.xmg_AlignVertical(type: XMG_AlignType.bottomLeft, referView: contentLabel, size: CGSize.zero, offset: CGPoint(x: 0, y: 10))
        pictureWidthCons = pictureView.xmg_Constraint(cons, attribute: NSLayoutAttribute.width)
        pictureHeightCons = pictureView.xmg_Constraint(cons, attribute: NSLayoutAttribute.height)
        
        
        // 添加底部约束
        let width = UIScreen.main.bounds.width
        footerView.xmg_AlignVertical(type: XMG_AlignType.bottomLeft, referView: pictureView, size: CGSize(width: width, height: 44), offset: CGPoint(x: -10, y: 10))
//        footerView.xmg_AlignInner(type: XMG_AlignType.bottomRight, referView: contentView, size: nil, offset: CGPoint(x: -10, y: -10))
    }
    
    /// 初始化配图的相关属性
    private func setupPictureView() {
        // 注册cell
        pictureView.register(PictureViewCell.self, forCellWithReuseIdentifier: kPictureViewCellId)
        pictureView.dataSource = self
        // 设置cell之间的间隙
        pictureLayout.minimumLineSpacing = 10
        pictureLayout.minimumInteritemSpacing = 10
        // 设置配图的背景颜色
        pictureView.backgroundColor = UIColor.white
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
    
    
    /// 计算配图的尺寸
    private func calculateImageSize() -> (viewSize:CGSize, itemSize:CGSize) {
        // 取出配图个数
        let count = status?.storedPicURLs?.count
        // 如果没有配图zero
        if count == 0 || count == nil {
            return (CGSize.zero, CGSize.zero)
        }
        
        // 如果只有一张配图，返回图片的实际大小
        if count == 1 {
            // 取出缓存的图片
            let key = status?.storedPicURLs?.first?.absoluteString
            let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: key!)
            return (image!.size, image!.size)
        }
        
        // 如果有4张配图，计算字格的大小
        let width = 90
        let margin = 10
        if count == 4 {
            let viewWidth = width * 2 + margin
            return (CGSize(width: viewWidth, height: viewWidth), CGSize(width: width, height: width))
        }
        
        // 如果是其他（多张），计算九宫格的大小
        let colNumber = 3
        let rowNumber = (count! - 1) / 3 + 1
        let viewWidth = colNumber * width + (colNumber - 1) * margin
        let viewHeight = rowNumber * width + (rowNumber - 1) * margin
        return (CGSize(width: viewWidth, height: viewHeight), CGSize(width: width, height: width))
    }
    
    
    // MARK: - 懒加载
    // 头像
    private lazy var iconView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "avatar_default_big"))
        return view
    }()
    
    // 认证图标
    private lazy var verifiedView: UIImageView = UIImageView(image: UIImage(named: "avatar_enterprise_vip"))
    
    // 昵称
//    private lazy var nameLabel: UILabel = {
//        let name = UILabel()
//        name.textColor = UIColor.darkGray
//        name.font = UIFont.systemFont(ofSize: 14)
//        return name
//    }()
    
    private lazy var nameLabel: UILabel = UILabel.createLabel(color: UIColor.darkGray, fontSize: 14)
    
    // 会员图标
    private lazy var vipView: UIImageView = UIImageView(image: UIImage(named: "common_icon_membership"))
    
    // 时间
    private lazy var timeLabel: UILabel = UILabel.createLabel(color: UIColor.darkGray, fontSize: 14)
    
    // 来源
    private lazy var sourceLabel: UILabel = UILabel.createLabel(color: UIColor.darkGray, fontSize: 14)
    
    // 正文
    private lazy var contentLabel: UILabel = {
        let label = UILabel.createLabel(color: UIColor.darkGray, fontSize: 15)
        label.numberOfLines = 0
//        label.font = UIFont.systemFont(ofSize: 15)
//        label.textColor = UIColor.darkGray
        label.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 20
        return label
    }()
    
    // 配图
    private lazy var pictureLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private lazy var pictureView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.pictureLayout)

    // 底部工具条
    private lazy var footerView: StatusFooterView = StatusFooterView()
    
}

class StatusFooterView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(retweetBtn)
        addSubview(unLikeBtn)
        addSubview(commonBtn)
        
        // 布局
        xmg_HorizontalTile([retweetBtn, unLikeBtn, commonBtn], insets: UIEdgeInsetsMake(0, 0, 0, 0))
    }
    
    // MARK: - 懒加载
    private lazy var retweetBtn: UIButton = UIButton.createButton(imageName: "timeline_icon_retweet", title: "转发")
    
    private lazy var unLikeBtn: UIButton = UIButton.createButton(imageName: "timeline_icon_unlike", title: "赞")
    
//    private lazy var commonBtn: UIButton = {
//        let btn = UIButton()
//        btn.setImage(UIImage(named: "timeline_icon_comment"), for: UIControlState.normal)
//        btn.setTitle("评论", for: UIControlState.normal)
//        btn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
//        btn.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
//        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
//        btn.setBackgroundImage(UIImage(named: "timeline_card_bottom_background"), for: UIControlState.normal)
//        return btn
//    }()
    
    private lazy var commonBtn: UIButton = UIButton.createButton(imageName: "timeline_icon_comment", title: "评论")
}


extension StatusTableViewCell:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return status?.storedPicURLs?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPictureViewCellId, for: indexPath) as! PictureViewCell
        if (status?.storedPicURLs?.count)! > indexPath.item {
            cell.imageUrl = status?.storedPicURLs![indexPath.item]
        }
        
        return cell
    }
}


class PictureViewCell: UICollectionViewCell {
    
    var imageUrl:NSURL? {
        didSet{
            iconView.sd_setImage(with: imageUrl! as URL!)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(iconView)
        
        iconView.xmg_Fill(contentView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var iconView = UIImageView ()
}







