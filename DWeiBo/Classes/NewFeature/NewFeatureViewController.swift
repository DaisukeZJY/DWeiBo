//
//  NewFeatureViewController.swift
//  DWeiBo
//
//  Created by DaiSuke on 2018/5/8.
//  Copyright © 2018年 DaiSuke. All rights reserved.
//

import UIKit

private let reuseIdentifier = "reuseIdentifier"
class NewFeatureViewController: UICollectionViewController {

    // 页面个数
    private let pageCount = 4
    // 布局对象
    private var layout:UICollectionViewFlowLayout = NewFeatureLayout()
    
    init() {
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 注册一个cell
        collectionView?.register(NewFeatureCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 获取cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! NewFeatureCell
        cell.imgaeIndex = indexPath.item
        return cell
    }

    // 完全显示完cell之后调用
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // 拿到当前显示的cell对应的索引
        let path = collectionView.indexPathsForVisibleItems.last
        print(path as Any)
        // 拿到当前索引对应的cell
        let cell = collectionView.cellForItem(at: path!) as! NewFeatureCell
        if path?.item == (pageCount - 1) {
            cell.startBtnAnimation()
        } else {
            cell.startBtnHidden(hidden: true)
        }
    }

}

private class NewFeatureCell: UICollectionViewCell {
    
    // 保存图片的索引
    // Swift中被private修饰的东西，如果同一个文件中是可以访问的
    var imgaeIndex:Int?{
        didSet {
            iconView.image = UIImage(named: "new_feature_\(imgaeIndex! + 1)")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 给按钮做个动画
    func startBtnAnimation() {
        startBtn.isHidden = false
        
        // 执行动画
        startBtn.transform = CGAffineTransform.init(scaleX: 0, y: 0)
        startBtn.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: {
            // 清空形变
            self.startBtn.transform = CGAffineTransform.identity
        }) { (_) in
            self.startBtn.isUserInteractionEnabled = true
        }
    }
    
    func startBtnHidden(hidden:Bool) {
        startBtn.isHidden = hidden
    }
    
    
    func setupUI() {
        // 添加到contentView控件上
        contentView.addSubview(iconView)
        contentView.addSubview(startBtn)
        
        iconView.xmg_Fill(contentView)
        startBtn.xmg_AlignInner(type: XMG_AlignType.bottomCenter, referView: contentView, size: nil, offset: CGPoint(x: 0, y: -160))
    }
    
    func clickStartBtn() {
        print("clickStartBtn")
        NotificationCenter.default.post(name: Notification.Name(rawValue: kSwitchRootViewControllerKey), object: true)
    }
    
    private lazy var iconView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var startBtn: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "new_feature_button"), for: UIControlState.normal)
        btn.setBackgroundImage(UIImage(named: "new_feature_button"), for: UIControlState.highlighted)
        btn.isHidden = true
        btn.addTarget(self, action: #selector(clickStartBtn), for: UIControlEvents.touchUpInside)
        return btn
    }()
}


/// 布局对象
private class NewFeatureLayout: UICollectionViewFlowLayout {
    
    // 重谢准备布局方法
    override func prepare() {
        // 设置layout布局
        itemSize = UIScreen.main.bounds.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.horizontal
        
        // 设置collectionView的属性
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.bounces = false
        collectionView?.isPagingEnabled = true
    }
}



