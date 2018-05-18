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

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.red
        // Do any additional setup after loading the view.
        
        setupUI()
        
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
        
        setupCollectionView()
    }

    private func setupToolbar() {
        toolBar.tintColor = UIColor.darkGray
        
        var items = [UIBarButtonItem]()
        var index = 0
        for str in ["最近", "默认", "emoji", "浪小花"] {
            let item = UIBarButtonItem(title: str, style: UIBarButtonItemStyle.plain, target: self, action: #selector(clickItem(item:)))
            index += 1
            item.tag = index
            items.append(item)
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil))
        }
        items.removeLast()
        toolBar.items = items
    }
    
    private func setupCollectionView() {
        collectionView.register(EmoticonCell.self, forCellWithReuseIdentifier: kEmoticonCellReuseIdentifier)
        collectionView.dataSource = self
    }
    
    func clickItem(item: UIBarButtonItem) {
        print(item.tag)
    }

    // MARK: - 懒加载
    private lazy var toolBar = UIToolbar()
    private lazy var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: EmoticonLayout())
}

extension EmoticonViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 21 * 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kEmoticonCellReuseIdentifier, for: indexPath) as! EmoticonCell
        cell.backgroundColor = (indexPath.item % 2 == 0) ? UIColor.red : UIColor.blue
        return cell
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
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(emoticonBtn)
        emoticonBtn.frame = bounds.insetBy(dx: 4, dy: 4)
        emoticonBtn.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var emoticonBtn = UIButton()
}
