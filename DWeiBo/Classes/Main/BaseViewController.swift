//
//  BaseViewController.swift
//  DWeiBo
//
//  Created by DaiSuke on 2016/11/1.
//  Copyright © 2016年 DaiSuke. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    // 定义一个变量保存用户当前是否是登录
    var userLogin = true
    
    // 定义属性保存未登录界面
    var visitorView: UIView?
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
