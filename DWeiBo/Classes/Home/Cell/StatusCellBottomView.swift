//
//  StatusCellBottomView.swift
//  DWeiBo
//
//  Created by DaiSuke on 2018/5/10.
//  Copyright © 2018年 DaiSuke. All rights reserved.
//

import UIKit

class StatusCellBottomView: UIView {

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

    private lazy var commonBtn: UIButton = UIButton.createButton(imageName: "timeline_icon_comment", title: "评论")
}
