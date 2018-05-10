//
//  StatusCellPictureView.swift
//  DWeiBo
//
//  Created by DaiSuke on 2018/5/10.
//  Copyright © 2018年 DaiSuke. All rights reserved.
//

import UIKit

class StatusCellPictureView: UICollectionView {

    var status:Status? {
        didSet{
            reloadData()
        }
    }
    
    private var pictureLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    init() {
        super.init(frame: CGRect.zero, collectionViewLayout: pictureLayout)
        
        // 注册cell
        register(PictureViewCell.self, forCellWithReuseIdentifier: kPictureViewCellId)
        dataSource = self
        // 设置cell之间的间隙
        pictureLayout.minimumLineSpacing = 10
        pictureLayout.minimumInteritemSpacing = 10
        // 设置配图的背景颜色
        backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 计算配图的尺寸
    func calculateImageSize() -> (viewSize:CGSize, itemSize:CGSize) {
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
    
}

extension StatusCellPictureView:UICollectionViewDataSource{
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

private class PictureViewCell: UICollectionViewCell {
    
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

