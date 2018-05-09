//
//  HomeTableViewController.swift
//  DWeiBo
//
//  Created by DaiSuke on 2016/10/27.
//  Copyright © 2016年 DaiSuke. All rights reserved.
//

import UIKit
import SVProgressHUD

// cell的标志
let kHomeCellReuseIdentifier = "kHomeCellReuseIdentifier"

class HomeTableViewController: BaseViewController {

    lazy var statuseFrames = NSArray();
    
    // 保存微博数组
    var statuses: [Status]? {
        didSet{
            // 设置数据完毕，刷新表格
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 如果没有登录，就设置未登录界面的信息
        if !userLogin {
            visitorView?.setupVisitorInfo(true, imageName: "visitordiscover_feed_image_house", message: "关注一些人，回这里看看有什么惊喜")
            return
        }
        
        // 初始化导航条
        setupNav()
        
        // 注册cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: kHomeCellReuseIdentifier)
        
        // 加载数据
        loadData()
    }

    func setupNav() {
        navigationItem.leftBarButtonItem = UIBarButtonItem.createBarButtonItem("navigationbar_friendattention", target: self, action: #selector(leftItemClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem.createBarButtonItem("navigationbar_pop", target: self, action: #selector(rightItemClick))
        
        let titleBtn = UIButton()
        titleBtn.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        titleBtn.setImage(UIImage(named: "navigationbar_arrow_down"), for: UIControlState.normal)
        titleBtn.setImage(UIImage(named: "navigationbar_arrow_up"), for: UIControlState.selected)
        titleBtn.setTitle(" WeiBo", for: UIControlState.normal)
        titleBtn.addTarget(self, action: #selector(titleItemClick(_:)), for: UIControlEvents.touchUpInside)
        titleBtn.sizeToFit()
        navigationItem.titleView = titleBtn
    }
    
    /// 加载数据
    func loadData() {
        Status.loadStatuses { (models, error) in
            if error != nil {
                return
            }
            self.statuses = models
        }
    }
    
    
    func leftItemClick()
    {
        print(#function)
    }
    
    func rightItemClick()
    {
        print(#function)
    }
    
    func titleItemClick(_ btn:UIButton)
    {
        btn.isSelected = !btn.isSelected
        print(#function)
    }

    
}


extension HomeTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return statuses?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kHomeCellReuseIdentifier, for: indexPath)
        if statuses!.count > indexPath.row {
            let status = statuses![indexPath.row]
            cell.textLabel?.text = status.text
        }
        return cell
    }
}

