//
//  PhotoSelectorController.swift
//  DWeiBo
//
//  Created by DaiSuke on 2018/5/21.
//  Copyright © 2018年 DaiSuke. All rights reserved.
//

import UIKit

let kPhotoSelectorCellReuseIdentifier = "kPhotoSelectorCellReuseIdentifier"
/// 最大选择照片数量
private let kMaxPhotoSelectCount = 9

class PhotoSelectorController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        
        view.addSubview(collectionView)
        
        // 设置layout
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        
        // 设置collectionView
        collectionView.backgroundColor = UIColor.lightGray
        collectionView.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: kPhotoSelectorCellReuseIdentifier)
        collectionView.dataSource = self
        
        // 设置布局
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        var cons = [NSLayoutConstraint]()
        cons += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["collectionView": collectionView])
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["collectionView": collectionView])
        view.addConstraints(cons)
    }
    
    // MARK: - 懒加载
    private lazy var layout = UICollectionViewFlowLayout()
    lazy var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.layout)
    lazy var photos = [UIImage]()
    
}

extension PhotoSelectorController: UICollectionViewDataSource, PhotoSelectorCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPhotoSelectorCellReuseIdentifier, for: indexPath) as! PhotoSelectorCell
        cell.backgroundColor = UIColor.randomColor()
        cell.delegate = self
        // 设置图片
        cell.image = indexPath.item < photos.count ? photos[indexPath.item] : nil
        return cell
    }
    
    // MARK: - PhotoSelectorCellDelegate
    func photoSelectorSelectPhoto(cell: PhotoSelectorCell) {
        
        /*
         UIIimagePickerController专门用来选择照片的
         PhotoLibrary : 照片库（所有的照片，拍照&用iTunes & photo 同步的照片，不能删除）
         SavePPhotosAlbum 相册（自助机拍摄的，可以删除）
         Camera 相机
         */
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            // 没有授权
            return
        }
        
        let vc = UIImagePickerController()
        vc.delegate = self
        
        // 允许编辑 - 如果上传头像，记得把这个属性打开
        // 能够建立一个正方形的图像，方便后续的头像处理
//        vc.allowsEditing = true
        
        present(vc, animated: true, completion: nil)
        
    }
    
    func photoSelectorRemovePhoto(cell: PhotoSelectorCell) {
        // indexpatch
        let indexPath = collectionView.indexPath(for: cell)
        
        // 删除照片
        photos.remove(at: indexPath!.item)
        
        // 更新
        collectionView.reloadData()
    }
    
    // MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // 提示：所有关于相册的处理，都需要处理内存
//        print(info)
        // 获取图片
//        print(info[UIImagePickerControllerOriginalImage] as Any)
        
        // 将图片保存到数组中
        if photos.count < kMaxPhotoSelectCount - 1 {
            photos.append(info[UIImagePickerControllerOriginalImage] as! UIImage)
            collectionView.reloadData()
        }
        // 关闭
        dismiss(animated: true, completion: nil)
    }
}

@objc
protocol PhotoSelectorCellDelegate: NSObjectProtocol {
    /// 要选择照片
    @objc optional func photoSelectorSelectPhoto(cell: PhotoSelectorCell)
    /// 要删除照片
    @objc optional func photoSelectorRemovePhoto(cell: PhotoSelectorCell)
}

class PhotoSelectorCell: UICollectionViewCell {
    
    // 不能解包可选项 -> 将nil使用了惊叹号
    var image:UIImage? {
        didSet{
            if image != nil {
                photoBtn.setImage(image, for: UIControlState.normal)
            } else {
                photoBtn.setImage(UIImage(named: "compose_pic_add"), for: UIControlState.normal)
                photoBtn.setImage(UIImage(named: "compose_pic_add_highlighted"), for: UIControlState.highlighted)
            }
            
            removeBtn.isHidden = (image == nil)
        }
    }
    
    /// 定义代理
    weak var delegate: PhotoSelectorCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(photoBtn)
        contentView.addSubview(removeBtn)
        
        photoBtn.translatesAutoresizingMaskIntoConstraints = false
        removeBtn.translatesAutoresizingMaskIntoConstraints = false
        var cons = [NSLayoutConstraint]()
        // 背景
        cons += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[photoButton]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["photoButton": photoBtn])
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[photoButton]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["photoButton": photoBtn])
        
        // 删除按钮
        cons += NSLayoutConstraint.constraints(withVisualFormat: "H:[removeButton]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["removeButton":removeBtn])
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[removeButton]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["removeButton":removeBtn])
        
        contentView.addConstraints(cons)
        
        // 设置监听方法
        photoBtn.addTarget(self, action: #selector(selectPhoto), for: UIControlEvents.touchUpInside)
        removeBtn.addTarget(self, action: #selector(removePhoto), for: UIControlEvents.touchUpInside)
    }
    
    
    
    func selectPhoto() {
        if image == nil {
            delegate?.photoSelectorSelectPhoto!(cell: self)
        }
    }
    
    func removePhoto() {
        delegate?.photoSelectorRemovePhoto!(cell: self)
    }
    
    // MARK: - 懒加载
    private lazy var photoBtn = PhotoSelectorCell.createBtn(imageName: "compose_pic_add")
    private lazy var removeBtn = PhotoSelectorCell.createBtn(imageName: "compose_photo_close")
    
    
    
    class func createBtn(imageName:String) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: imageName), for: UIControlState.normal)
        button.setImage(UIImage(named: imageName + "_highlighted"), for: UIControlState.highlighted)
        return button
    }
    
}
