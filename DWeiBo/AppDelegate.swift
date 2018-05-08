//
//  AppDelegate.swift
//  DWeiBo
//
//  Created by DaiSuke on 2016/10/27.
//  Copyright © 2016年 DaiSuke. All rights reserved.
//

import UIKit

/// 切换控制器通知
let kSwitchRootViewControllerKey = "kSwitchRootViewControllerKey"


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func isNewUpdate() -> Bool {
        // 获取当前版本信息
        let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        let version = NumberFormatter().number(from: currentVersion)?.doubleValue ?? 0
        
        // 获取沙盒版本信息
        let versionKey = "versionKey"
        let sandboxVersion = UserDefaults.standard.double(forKey: versionKey)
        
        // 保存当前版本
        UserDefaults.standard.set(version, forKey: versionKey)
        return version > sandboxVersion
    }
    
    private func defaultController() -> UIViewController{
        // 判断用户是否登录
        if UserAccount.userLogin() {
            return isNewUpdate() ? NewFeatureViewController() : WelcomViewController()
        }
        return MainViewController()
    }
    
    func switchRootViewController(notify:Notification) {
        if notify.object as! Bool {
            window?.rootViewController = MainViewController()
        } else {
            window?.rootViewController = WelcomViewController()
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // 注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(switchRootViewController(notify:)), name: NSNotification.Name(rawValue: kSwitchRootViewControllerKey), object: nil)
        
        // 设置导航条和工具条的外观
        // 因为外观一旦设置全局有效, 所以应该在程序一进来就设置
        UINavigationBar.appearance().tintColor = UIColor.orange
        UITabBar.appearance().tintColor = UIColor.orange
        
        // 创建window
        window = UIWindow(frame:UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        // 创建根控制器
//        window?.rootViewController = MainViewController()
//        window?.rootViewController = NewFeatureViewController()
        window?.rootViewController = defaultController()
        window?.makeKeyAndVisible()
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

