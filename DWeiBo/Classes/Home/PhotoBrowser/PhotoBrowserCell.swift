//
//  PhotoBrowserCell.swift
//  DWeiBo
//
//  Created by DaiSuke on 2018/5/16.
//  Copyright © 2018年 DaiSuke. All rights reserved.
//

import UIKit
import SDWebImage

protocol PhotoBrowserCellDelegate: NSObjectProtocol {
    /// 结束缩放
    func photoBrowserCellDidTapImageView()
}

class PhotoBrowserCell: UICollectionViewCell {
    
    // 声明代理属性
    weak var photoDelegate:PhotoBrowserCellDelegate?
    
    
    // 图片的URL
    var imageURL: NSURL? {
        didSet{
            self.indicator.startAnimating()
            
            // 重设scrollview
            resetScrollView()
            
            imageView.sd_setImage(with: imageURL as URL?, placeholderImage: nil, options: SDWebImageOptions.retryFailed) { (_, _, _, _) in
//                self.imageView.sizeToFit()
                self.indicator.stopAnimating()
                
                self.setupImagePosition()
            }
        }
    }
    
    /// 重设scrollview的偏移属性
    private func resetScrollView() {
        imageView.transform = CGAffineTransform.identity
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.contentOffset = CGPoint.zero
        scrollView.contentSize = CGSize.zero
    }
    
    ///
    private func setupImagePosition() {
        let size = self.displaySize(image: imageView.image!)
        // 图像高度比视图高度小，短图
        if size.height < scrollView.bounds.size.height {
            // 垂直居中
            let y = (scrollView.bounds.size.height - size.height) * 0.5
            imageView.frame = CGRect(origin: CGPoint.zero, size: size)
            // 设置间距，能够保证缩放完成后，同样能够显示完整画面
            scrollView.contentInset = UIEdgeInsetsMake(y, 0, y, 0)
        } else {
            // 长图
            imageView.frame = CGRect(origin: CGPoint.zero, size: size)
            scrollView.contentSize = size
        }
    }
    
    /// 计算显示的图像尺寸，以scrollview的宽度为准
    private func displaySize(image:UIImage) -> CGSize {
        // 图像宽高比
        let scale = image.size.height / image.size.width
        let height = scale * scrollView.bounds.size.width
        return CGSize(width: scrollView.bounds.size.width, height: height)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        
    }
    
    private func setupUI() {
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)
        contentView.addSubview(indicator)
        
        scrollView.frame = UIScreen.main.bounds
        indicator.center = scrollView.center
        
        // 添加imageView手势监听
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickImageView))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
    }
    
    func clickImageView() {
        photoDelegate?.photoBrowserCellDidTapImageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.delegate = self
        // 最大/最小缩放比例
        view.minimumZoomScale = 0.5
        view.maximumZoomScale = 2.0
        return view
    }()
    lazy var imageView = UIImageView()
    
    // 菊花
    lazy var indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
}


extension PhotoBrowserCell: UIScrollViewDelegate {
    
    /// 告诉scrollview要缩放的控件
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    /**
     在缩放完成后，会被调用一次
     view：被缩放的view
     scale：缩放完成后的缩放比例
     */
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        // 重新计算间距
        // 通过transform改变view的缩放，bound本身没有变化，frame会变化
        var offsetX = (scrollView.bounds.width - view!.frame.size.width) * 0.5
        // 如果边距小于0，需要修正
        offsetX = offsetX < 0 ? 0 : offsetX
        
        var offsetY = (scrollView.bounds.size.height - view!.frame.size.height) * 0.5
        offsetY = offsetY < 0 ? 0 : offsetY
        
        scrollView.contentInset = UIEdgeInsetsMake(offsetY, offsetX, 0, 0)
        
    }
}

