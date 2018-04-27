//
//  MainViewController.swift
//  DWeiBo
//
//  Created by DaiSuke on 2016/10/27.
//  Copyright © 2016年 DaiSuke. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
        // 设置当前控制器对应tabbar的颜色
        // 注意：在iOS7以前如果设置来了titColor只有文字会变，图片不会变
        tabBar.tintColor = UIColor.orange
        
        // 添加子控制器
        addChildViewControllers()
        
        // 从iOS7开始就不推荐大家在viewDidLoad中设置frame
//        print(tabBar.subviews)
        // 为空
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        print("-----")
//        print(tabBar.subviews)
        // 有值，有frame
        addComposeButton()
    }
    
    fileprivate func addComposeButton(){
        
        // 添加按钮
        tabBar.addSubview(composeBtn)
        
        // 调整加好按钮的位置
        print("\((viewControllers?.count)! + 1)")
        let width = UIScreen.main.bounds.size.width / CGFloat(viewControllers!.count)
        let rect = CGRect(x: 0, y: 0, width: width, height: 49)
        
        composeBtn.frame = rect.offsetBy(dx: 2 * width, dy: 0)
        
        
    }
    
    fileprivate func addChildViewControllers() {
        // 获取json文件的路径
        let path = Bundle.main.path(forResource: "MainVCSetting.json", ofType: nil)
        
        if let pathName = path {
            let jsonData = try!Data(contentsOf:URL(fileURLWithPath: pathName))
            
            do {
                // 有可能异常代码放在这里
                // 序列化json数据 --> Array
                // try: 发生异常会跳到catch中继续执行
                // try!: 发生过异常程序直接崩溃
                let dicArr = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers)
                
                // 遍历数组,动态创建控制器和设置数据
                // 在swift中，如果需要遍历一个数组，必须明确数据类型
                for dic in dicArr as! [[String: String]] {
                    // 报错的原因是因为addChildViewController参数必须有值，但是字典返回的是可选值
                    //                    addChildViewController(dic["vcName"], title: dic["title"], imageName: dic["imageName"])
                    addChildViewController(dic["vcName"]!, title: dic["title"]!, imageName: dic["imageName"]!)
                }
                
                
            } catch  {
                
                // 发生异常之后会执行的代码
                print(error)
                
                //从本地创建子控制器
                addChildViewController("HomeTableViewController", title: "首页", imageName: "tabbar_home")
                addChildViewController("MessageTableViewController", title: "消息", imageName: "tabbar_message_center")
                // 再添加一个占位控制器
                addChildViewController("NullViewController", title: "", imageName: "")
                addChildViewController("DiscoverTableViewController", title: "广场", imageName: "tabbar_discover")
                addChildViewController("ProfileTableViewController", title: "我", imageName: "tabbar_profile")
            }
            
        }

    }
    
    /// 初始化子控制器
    ///
    /// - parameter childController: 需要初始化的子控制器
    /// - parameter title:           标题
    /// - parameter imageName:       图片
    fileprivate func addChildViewController(_ childControllerName: String, title:String, imageName:String) {
        
        // 设置首页对应的数据
//        childController.title = title
//        childController.tabBarItem.image = UIImage(named:imageName)
//        childController.tabBarItem.selectedImage = UIImage(named:imageName+"_highlighted")
        // 动态获取命名空间
        let bundleString = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        
        // 将字符串转为类
        let className:AnyClass? = NSClassFromString(bundleString + "." + childControllerName)
        
        // 通过类创建对象
        // 将AnyClass转为指定的类型
        let vcClass = className as! UIViewController.Type
        // 通过class创建对象
        let vc = vcClass.init()
        
        vc.title = title
//        vc.tabBarItem.image = UIImage(named:imageName)
        vc.tabBarItem.image = UIImage.init(named: imageName)
        vc.tabBarItem.selectedImage = UIImage(named:imageName+"_highlighted")
        
        // 包装一个导航器
        let navController = UINavigationController()
        navController.addChildViewController(vc)
        
        // 将导航器添加到当前控制器
        addChildViewController(navController)
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
    
    // MARK: -懒加载
    fileprivate lazy var composeBtn:UIButton = {
        let button = UIButton()
        
        // 设置前置图片
        button.setImage(UIImage(named:"tabbar_compose_icon_add"), for: UIControlState.normal)
    button.setImage(UIImage(named:"tabbar_compose_icon_add_highlighted"), for: UIControlState.highlighted)
        
        // 设置背景图片
        button.setBackgroundImage(UIImage(named:"tabbar_compose_button"), for: UIControlState.normal)
        button.setBackgroundImage(UIImage(named:"tabbar_compose_button_highlighted"), for: UIControlState.highlighted)
        
        // 添加监听事件
        button.addTarget(self, action: #selector(composeBtnClick), for: UIControlEvents.touchUpInside)
        
        return button
        
    }()
    
    /// 监听加好按钮点击，注意：监听按钮点击方法不能私有
    /// 按钮点击事件的调用是由  运行循环 监听并且以消息机制传递的，因此，按钮监听函数不能设置为fileprivate
    func composeBtnClick() {
        print(#function)
        print("点击按钮")
    }

}
