//
//  DiscoverTableViewController.swift
//  DWeiBo
//
//  Created by DaiSuke on 2016/10/27.
//  Copyright © 2016年 DaiSuke. All rights reserved.
//

import UIKit

class DiscoverTableViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 初始化导航条
        setupNav()
    }
    
    func setupNav() {
        navigationItem.leftBarButtonItem = UIBarButtonItem.createBarButtonItem("navigationbar_friendattention", target: self, action: #selector(leftItemClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem.createBarButtonItem("navigationbar_pop", target: self, action: #selector(rightItemClick))
        
    }
    
    func leftItemClick()
    {
        print(#function)
        present(EmoticonViewController(), animated: true, completion: nil)
    }
    
    func rightItemClick()
    {
        print(#function)
    }

}
