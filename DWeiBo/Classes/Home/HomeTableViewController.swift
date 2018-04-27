//
//  HomeTableViewController.swift
//  DWeiBo
//
//  Created by DaiSuke on 2016/10/27.
//  Copyright © 2016年 DaiSuke. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    lazy var statuseFrames = NSArray();
    
    // 顶部刷新
//    let header = MJRefreshNormalHeader()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 加载继承刷新
        self.setupRefreshStatuse();
    }

    func setupRefreshStatuse() {
        let head:UIRefreshControl = UIRefreshControl.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 150))
        head.tintColor = UIColor.black;
        head.attributedTitle = NSAttributedString.init(string: "下拉刷新")
        self.tableView.addSubview(head)
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    

}
