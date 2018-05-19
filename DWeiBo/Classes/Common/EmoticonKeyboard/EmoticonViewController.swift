//
//  EmoticonViewController.swift
//  DWeiBo
//
//  Created by DaiSuke on 2018/5/17.
//  Copyright © 2018年 DaiSuke. All rights reserved.
//

import UIKit

let kEmoticonCellReuseIdentifier = "kEmoticonCellReuseIdentifier"

class EmoticonViewController: UIViewController {
    
    /// 定义一个闭包属性，用于传递选中的表情模型
    var emoticonDidSelectedCallBack: (_ emoticon: Emoticon)->()
    
    init(callBack:@escaping (_ emoticon: Emoticon)->()) {
        self.emoticonDidSelectedCallBack = callBack
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.red
        // Do any additional setup after loading the view.
        
        setupUI()
        
//        EmoticonPackage.packages()
        
    }
    
    func setupUI(){
        view.addSubview(toolBar)
        view.addSubview(collectionView)
        
        // 自动局部
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        var cons = [NSLayoutConstraint]()
        let viewDict = ["collectionView": collectionView, "toolBar": toolBar]
        
        cons += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict)
        cons += NSLayoutConstraint.constraints(withVisualFormat:"H:|-0-[toolBar]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict)
        cons += NSLayoutConstraint.constraints(withVisualFormat:"V:|-0-[collectionView]-0-[toolBar(44)]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict)
        
        // 添加约束
        view.addConstraints(cons)
        
        // 初始化工具条
        setupToolbar()
        
//        setupCollectionView()
    }

    private func setupToolbar() {
        toolBar.tintColor = UIColor.darkGray
        
        var items = [UIBarButtonItem]()
        var index = 0
        for str in ["最近", "默认", "emoji", "浪小花"] {
            let item = UIBarButtonItem(title: str, style: UIBarButtonItemStyle.plain, target: self, action: #selector(clickItem(item:)))
            item.tag = index
            index += 1
            items.append(item)
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil))
        }
        items.removeLast()
        toolBar.items = items
    }
    
//    private func setupCollectionView() {
//        collectionView.register(EmoticonCell.self, forCellWithReuseIdentifier: kEmoticonCellReuseIdentifier)
//        collectionView.dataSource = self
//    }
    
    func clickItem(item: UIBarButtonItem) {
        print(item.tag)
        let indexPath = NSIndexPath(item: 0, section: item.tag)
        collectionView.scrollToItem(at: indexPath as IndexPath, at: UICollectionViewScrollPosition.left, animated: true)
    }

    // MARK: - 懒加载
    private lazy var toolBar = UIToolbar()
//    private lazy var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: EmoticonLayout())
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: EmoticonLayout())
        collectionView.register(EmoticonCell.self, forCellWithReuseIdentifier: kEmoticonCellReuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    lazy var packages: [EmoticonPackage] = EmoticonPackage.packages()
}

extension EmoticonViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return packages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return packages[section].emoticons?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kEmoticonCellReuseIdentifier, for: indexPath) as! EmoticonCell
        cell.backgroundColor = (indexPath.item % 2 == 0) ? UIColor.red : UIColor.blue
        cell.emoticon = packages[indexPath.section].emoticons![indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 获取表情模型
        let emoticon = packages[indexPath.section].emoticons![indexPath.item]
        // 处理最近表情，将当前使用的表情添加到最近表情的数组中
        emoticon.times += 1
        packages[0].appendEmoticons(emoticon: emoticon)
        // 执行闭包
        emoticonDidSelectedCallBack(emoticon)
    }
    
}

private class EmoticonLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        let width = collectionView!.bounds.size.width / 7
        itemSize = CGSize(width: width, height: width)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.horizontal
        
        // 由于不CGFloat准确，所以不要写0.5，可能出现只显示2
        let y = (collectionView!.bounds.size.height - 3 * width) * 0.45
        collectionView?.contentInset = UIEdgeInsetsMake(y, 0, y, 0)
        
        collectionView?.isPagingEnabled = true
        collectionView?.bounces = false
    }
}


class EmoticonCell: UICollectionViewCell {
    
    var emoticon: Emoticon? {
        didSet{
            // 设置图片
            if let path = emoticon?.imagePath {
                emoticonBtn.setImage(UIImage(named: path), for: UIControlState.normal)
            } else {
                // 防止cell的重用
                emoticonBtn.setImage(nil, for: UIControlState.normal)
            }
            // 设置emoji，直接过滤调用cell重用的问题
            emoticonBtn.setTitle(emoticon?.emoji ?? "", for: UIControlState.normal)
            
            // 设置删除按钮
            if emoticon!.removeBtn {
                emoticonBtn.setImage(UIImage(named: "compose_emotion_delete"), for: UIControlState.normal)
                emoticonBtn.setImage(UIImage(named: "compose_emotion_delete_highlighted"), for: UIControlState.highlighted)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(emoticonBtn)
        emoticonBtn.frame = bounds.insetBy(dx: 4, dy: 4)
        emoticonBtn.backgroundColor = UIColor.white
        emoticonBtn.isUserInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var emoticonBtn: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        return btn
    }()
}
