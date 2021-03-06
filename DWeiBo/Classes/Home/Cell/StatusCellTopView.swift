//
//  StatusCellTopView.swift
//  DWeiBo
//
//  Created by DaiSuke on 2018/5/10.
//  Copyright © 2018年 DaiSuke. All rights reserved.
//

import UIKit

class StatusCellTopView: UIView {

    var status:Status? {
        didSet{
            nameLabel.text = status?.user?.name
            timeLabel.text = status?.created_at
            sourceLabel.text = status?.source
            if let url = status?.user?.profile_image_url {
                iconView.sd_setImage(with: URL(string: url))
            }
            
            // 设置会员图标
            verifiedView.image = status?.user?.verifiedImage
            vipView.image = status?.user?.mbrankImage
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 初始化UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(iconView)
        addSubview(verifiedView)
        addSubview(nameLabel)
        addSubview(vipView)
        addSubview(timeLabel)
        addSubview(sourceLabel)
        
        // 布局
        iconView.xmg_AlignInner(type: XMG_AlignType.topLeft, referView: self, size: CGSize(width: 50, height: 50), offset: CGPoint(x: 10, y: 10))
        verifiedView.xmg_AlignInner(type: XMG_AlignType.bottomRight, referView: iconView, size: CGSize(width: 14, height: 14), offset: CGPoint(x: 5, y: 5))
        nameLabel.xmg_AlignHorizontal(type: XMG_AlignType.topRight, referView: iconView, size: nil, offset: CGPoint(x: 10, y: 0))
        vipView.xmg_AlignHorizontal(type: XMG_AlignType.topRight, referView: nameLabel, size: nil, offset: CGPoint(x: 10, y: 0))
        timeLabel.xmg_AlignHorizontal(type: XMG_AlignType.bottomRight, referView: iconView, size: nil, offset: CGPoint(x: 10, y: 0))
        sourceLabel.xmg_AlignHorizontal(type: XMG_AlignType.bottomRight, referView: timeLabel, size: nil, offset: CGPoint(x: 10, y: 0))
       
    }
    
    // MARK: - 懒加载
    // 头像
    private lazy var iconView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "avatar_default_big"))
        return view
    }()
    
    // 认证图标
    private lazy var verifiedView: UIImageView = UIImageView(image: UIImage(named: "avatar_enterprise_vip"))
    
    
    private lazy var nameLabel: UILabel = UILabel.createLabel(color: UIColor.darkGray, fontSize: 14)
    
    // 会员图标
    private lazy var vipView: UIImageView = UIImageView(image: UIImage(named: "common_icon_membership"))
    
    // 时间
    private lazy var timeLabel: UILabel = UILabel.createLabel(color: UIColor.darkGray, fontSize: 14)
    
    // 来源
    private lazy var sourceLabel: UILabel = UILabel.createLabel(color: UIColor.darkGray, fontSize: 14)


}
