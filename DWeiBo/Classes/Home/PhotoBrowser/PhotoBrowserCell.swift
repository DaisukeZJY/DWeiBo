//
//  PhotoBrowserCell.swift
//  DWeiBo
//
//  Created by DaiSuke on 2018/5/16.
//  Copyright © 2018年 DaiSuke. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoBrowserCell: UICollectionViewCell {
    
    // 图片的URL
    var imageURL: NSURL? {
        didSet{
            
            imageView.sd_setImage(with: imageURL as URL?, placeholderImage: nil, options: SDWebImageOptions.retryFailed) { (_, _, _, _) in
                self.imageView.sizeToFit()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        
    }
    
    private func setupUI() {
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)
        
        scrollView.frame = UIScreen.main.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var scrollView = UIScrollView()
    lazy var imageView = UIImageView()
}
