//
//  StatusNormalTableViewCell.swift
//  DWeiBo
//
//  Created by DaiSuke on 2018/5/11.
//  Copyright © 2018年 DaiSuke. All rights reserved.
//

import UIKit

class StatusNormalTableViewCell: StatusTableViewCell {

    override func setupUI() {
        super.setupUI()
        
        let cons = pictureView.xmg_AlignVertical(type: XMG_AlignType.bottomLeft, referView: contentLabel, size: CGSize.zero, offset: CGPoint(x: 0, y: 10))
        
        pictureWidthCons = pictureView.xmg_Constraint(cons, attribute: NSLayoutAttribute.width)
        pictureHeightCons = pictureView.xmg_Constraint(cons, attribute: NSLayoutAttribute.height)
        
    }
}
