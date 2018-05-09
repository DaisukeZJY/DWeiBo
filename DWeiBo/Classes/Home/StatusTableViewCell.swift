//
//  StatusTableViewCell.swift
//  DWeiBo
//
//  Created by DaiSuke on 2018/5/9.
//  Copyright © 2018年 DaiSuke. All rights reserved.
//

import UIKit
import SDWebImage

class StatusTableViewCell: UITableViewCell {

    var status:Status? {
        didSet{
            nameLabel.text = status?.user?.name
//            timeLabel.text = status?.created_at
//            sourceLabel.text = status?.source
            timeLabel.text = "刚刚"
            sourceLabel.text = "来自：daisuke"
            contentLabel.text = status?.text
            iconView.sd_setImage(with: URL(string: (status?.user?.profile_image_url)!))
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
    
    private func setupUI() {
        contentView.addSubview(iconView)
        contentView.addSubview(verifiedView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(vipView)
        contentView.addSubview(timeLabel)
        contentView.addSubview(sourceLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(footerView)
        
        // 布局
        iconView.xmg_AlignInner(type: XMG_AlignType.topLeft, referView: contentView, size: CGSize(width: 50, height: 50), offset: CGPoint(x: 10, y: 10))
        verifiedView.xmg_AlignInner(type: XMG_AlignType.bottomRight, referView: iconView, size: CGSize(width: 14, height: 14), offset: CGPoint(x: 5, y: 5))
        nameLabel.xmg_AlignHorizontal(type: XMG_AlignType.topRight, referView: iconView, size: nil, offset: CGPoint(x: 10, y: 0))
        vipView.xmg_AlignHorizontal(type: XMG_AlignType.topRight, referView: nameLabel, size: nil, offset: CGPoint(x: 10, y: 0))
        timeLabel.xmg_AlignHorizontal(type: XMG_AlignType.bottomRight, referView: iconView, size: nil, offset: CGPoint(x: 10, y: 0))
        sourceLabel.xmg_AlignHorizontal(type: XMG_AlignType.bottomRight, referView: timeLabel, size: nil, offset: CGPoint(x: 10, y: 0))
        contentLabel.xmg_AlignVertical(type: XMG_AlignType.bottomLeft, referView: iconView, size: nil, offset: CGPoint(x: 0, y: 10))
        
        // 添加底部约束
        let width = UIScreen.main.bounds.width
        footerView.xmg_AlignVertical(type: XMG_AlignType.bottomLeft, referView: contentLabel, size: CGSize(width: width, height: 44), offset: CGPoint(x: -10, y: 10))
        footerView.xmg_AlignInner(type: XMG_AlignType.bottomRight, referView: contentView, size: nil, offset: CGPoint(x: -10, y: -10))
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
    private lazy var nameLabel: UILabel = {
        let name = UILabel()
        name.textColor = UIColor.darkGray
        name.font = UIFont.systemFont(ofSize: 14)
        return name
    }()
    
    // 会员图标
    private lazy var vipView: UIImageView = UIImageView(image: UIImage(named: "common_icon_membership"))
    
    // 时间
    private lazy var timeLabel: UILabel = {
        let time = UILabel()
        time.textColor = UIColor.darkGray
        time.font = UIFont.systemFont(ofSize: 14)
        return time
    }()
    
    // 来源
    private lazy var sourceLabel: UILabel = {
        let source = UILabel()
        source.textColor = UIColor.darkGray
        source.font = UIFont.systemFont(ofSize: 14)
        return source
    }()
    
    // 正文
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.darkGray
        label.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 20
        return label
    }()

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
    private lazy var retweetBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "timeline_icon_retweet"), for: UIControlState.normal)
        btn.setTitle("转发", for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        btn.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
        btn.setBackgroundImage(UIImage(named: "timeline_card_bottom_background"), for: UIControlState.normal)
        return btn
    }()
    
    private lazy var unLikeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "timeline_icon_unlike"), for: UIControlState.normal)
        btn.setTitle("赞", for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        btn.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
        btn.setBackgroundImage(UIImage(named: "timeline_card_bottom_background"), for: UIControlState.normal)
        return btn
    }()
    
    private lazy var commonBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "timeline_icon_comment"), for: UIControlState.normal)
        btn.setTitle("评论", for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        btn.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
        btn.setBackgroundImage(UIImage(named: "timeline_card_bottom_background"), for: UIControlState.normal)
        return btn
    }()
    
}










