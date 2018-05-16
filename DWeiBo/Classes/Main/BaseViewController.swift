//
//  BaseViewController.swift
//  DWeiBo
//
//  Created by DaiSuke on 2016/11/1.
//  Copyright © 2016年 DaiSuke. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, VisitorViewDelegate {
    
    var navHeight:CGFloat {
        return (navigationController?.navigationBar.frame.size.height)!
    }
    
    var tabbarHeight:CGFloat {
        return UIApplication.shared.statusBarFrame.size.height
    }
    
    
    func loginBtnWillClick() {
        print(#function)
        // 弹出登录界面
        let vc = OAuthViewController()
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
        
        
    }
    
    func registerBtnWillClick() {
        print(#function)
    }
    
    
    // 定义一个变量保存用户当前是否是登录
    var userLogin = UserAccount.userLogin()
    
    // 定义属性保存未登录界面
    var visitorView: VisitorView?
    
    override func loadView() {
        userLogin ? super.loadView() : setupVisitorView()
    }
    
    fileprivate func setupVisitorView(){
        // 初始化未登录界面
        let visitorView = VisitorView()
        visitorView.delegate = self
        view = visitorView
        
        // 设置导航条未登录按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.plain, target: self, action: #selector(BaseViewController.registerBtnWillClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.plain, target: self, action: #selector(BaseViewController.loginBtnWillClick))
    }
    
    
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
