//
//  StatusCellPictureView.swift
//  DWeiBo
//
//  Created by DaiSuke on 2018/5/10.
//  Copyright © 2018年 DaiSuke. All rights reserved.
//

import UIKit

/// 选中照片通知
let kStatusCellSelectPictureNotify = "kStatusCellSelectPictureNotify"
/// 照片的URL
let kStatusCellSelectPictureURLNotify = "kStatusCellSelectPictureURLNotify"
/// 照片的index
let kStatusCellSelectPictureIndexNotify = "kStatusCellSelectPictureIndexNotify"

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
        delegate = self
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
    func calculateImageSize() -> CGSize {
        // 取出配图个数
        let count = status?.storedPicURLs?.count
        // 如果没有配图zero
        if count == 0 || count == nil {
            return CGSize.zero
        }
        
        // 如果只有一张配图，返回图片的实际大小
        if count == 1 {
            // 取出缓存的图片
            let key = status?.storedPicURLs?.first?.absoluteString
            let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: key!)
            pictureLayout.itemSize = image!.size
            return image!.size
        }
        
        // 如果有4张配图，计算字格的大小
        let width = 90
        let margin = 10
        pictureLayout.itemSize = CGSize(width: width, height: width)
        if count == 4 {
            let viewWidth = width * 2 + margin
            return CGSize(width: viewWidth, height: viewWidth)
        }
        
        // 如果是其他（多张），计算九宫格的大小
        let colNumber = 3
        let rowNumber = (count! - 1) / 3 + 1
        let viewWidth = colNumber * width + (colNumber - 1) * margin
        let viewHeight = rowNumber * width + (rowNumber - 1) * margin
        return CGSize(width: viewWidth, height: viewHeight)
    }
    
}

extension StatusCellPictureView: UICollectionViewDataSource, UICollectionViewDelegate{
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 拿到当前点击图片
//        print(status?.pictureURLs![indexPath.item])
//        print(status?.storedPicURLs![indexPath.item])
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kStatusCellSelectPictureNotify), object: self, userInfo: [kStatusCellSelectPictureURLNotify:status!.storeLargePictureURLs!, kStatusCellSelectPictureIndexNotify:indexPath])
        
    }
    
}

private class PictureViewCell: UICollectionViewCell {
    
    var imageUrl:NSURL? {
        didSet{
            iconView.sd_setImage(with: imageUrl! as URL?)
            
            // 设置时候显示gif图标
            gifImageView.isHidden = ((imageUrl!.absoluteString! as NSString).pathExtension.lowercased() != "gif")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(iconView)
        contentView.addSubview(gifImageView)
        
        iconView.xmg_Fill(contentView)
        gifImageView.xmg_AlignInner(type: XMG_AlignType.bottomRight, referView: iconView, size: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var iconView = UIImageView ()
    lazy var gifImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "timeline_image_gif")
        view.isHidden = true
        return view
    }()
}

