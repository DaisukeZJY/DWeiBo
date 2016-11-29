---
title: MyWeiBoProjectForSwift
date: 2016-10-27 14:24:34
tags: Swift
categories: Swift
keywords: 微博, Swift

---

> 其实`Swift`的基础知识还没有学完，但是觉得很鼓噪，多以直接奔着项目去了。这次写的不是别的，是培训常模仿的微博项目，现在我也是边模仿边学习的心态。我会记录小码哥中模仿`微博`的从`0`到`1`的过程，希望以后看到自己写的烂文章会笑起来，哈哈。

![](http://obyghtd4m.bkt.clouddn.com/weibo4AC4757E-82B3-4134-B3C7-3D71F7B4B6E7.png)

> 另外文章篇幅可能很长很长，所以想看的同学可以好好收藏一下。如果觉得可以帮助到你的话，请`Star`我，也可以`Fort`一下工程关注项目的进展情况。当然过程中有什么问题的话，随时欢迎`Issues`,或者你有更好的方案也欢迎`Pull`。

> 欢迎转载，但是请注明出处，劳动成果来之不易。


<!-- more-->

## 工程地址
[MyWeiBoProjectForSwift](https://github.com/DaisukeZJY/DWeiBo/tree/master)
另外资源可以在工程里面找


## 创建工程

相信大家都会了，这里就不在述说了

## 删除StoryBoard

使用纯代码完成这个项目，所以先把故事版删除，还有把`info.plist`文件的`main`删除。如下图
![](http://obyghtd4m.bkt.clouddn.com/weibo0766F05D-FFED-46B2-8C3F-EAE3102D3281.png)

## 框架搭建

* 首先建立工程目录

按照微博的模块，可以分为`首页(Home)`、`消息(Message)`、`广场(Discover)`、`我(Profile)`四大模块，然后工程在同级别添加`Main`、`Common`、`Tool`三个模块
如下图：
![](http://obyghtd4m.bkt.clouddn.com/5D4BE60E-A00C-4BFE-AC5A-836CE464DE20.png)


* 搭建框架

在`Main`模块中新建一个继承`UITabBarController`的自定`义MainViewController`类
那么好了，我们只要在`AppDelegate.swift`文件中创建Window，并把`rootController`赋值`MainViewController`就行了。


* 在AppDelegate.swift创建视图

```swift

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
// Override point for customization after application launch.

    // 创建window
    window = UIWindow(frame:UIScreen.main.bounds)
    window?.backgroundColor = UIColor.white
    // 创建根控制器
    window?.rootViewController = MainViewController()
    window?.makeKeyAndVisible()

    return true
}

```

* 在首页(Home)、消息(Message)、广场(Discover)、我(Profile)模块建立主要控制器

分别对应`HomeTableViewController`、`MessageTableViewController`、`DiscoverTableViewController`、`ProfileTableViewController`


* MainViewController创建子控制器

```swift
override func viewDidLoad() {
super.viewDidLoad()

    // 设置当前控制器对应tabbar的颜色
    // 注意：在iOS7以前如果设置来了titColor只有文字会变，图片不会变
    tabBar.tintColor = UIColor.orange

    //  创建首页子控制器
    let homeVC = HomeTableViewController()
    homeVC.title = "首页"
    homeVC.tabBarItem.image = UIImage(named: "tabbar_home")
    homeVC.tabBarItem.selectedImage = UIImage(named:imageName+"_highlighted")

    // 创建导航控制器包装一下
    let homeNavC = UINavigationController()
    homeNavC.addChildViewController(homeVC)

    // 将导航控制器添加到当前控制器
    addChildViewController(homeNavC)


    //  创建消息子控制器
    let messageVC = MessageTableViewController()
    messageVC.title = "消息"
    messageVC.tabBarItem.image = UIImage(named: "tabbar_message_center")
    messageVC.tabBarItem.selectedImage = UIImage(named:imageName+"_highlighted")

    // 创建导航控制器包装一下
    let messageNavC = UINavigationController()
    messageNavC.addChildViewController(messageVC)

    // 将导航控制器添加到当前控制器
    addChildViewController(messageNavC)


    //  创建广场子控制器
    let discoverVC = DiscoverTableViewController()
    discoverVC.title = "广场"
    discoverVC.tabBarItem.image = UIImage(named: "tabbar_discover")
    discoverVC.tabBarItem.selectedImage = UIImage(named:imageName+"_highlighted")

    // 创建导航控制器包装一下
    let discoverNavC = UINavigationController()
    discoverNavC.addChildViewController(discoverVC)

    // 将导航控制器添加到当前控制器
    addChildViewController(discoverNavC)


    //  创建我子控制器
    let profileVC = ProfileTableViewController()
    profileVC.title = "我"
    profileVC.tabBarItem.image = UIImage(named: "tabbar_profile")
    profileVC.tabBarItem.selectedImage = UIImage(named:imageName+"_highlighted")

    // 创建导航控制器包装一下
    let profileNavC = UINavigationController()
    profileNavC.addChildViewController(profileVC)

    // 将导航控制器添加到当前控制器
    addChildViewController(profileNavC)

}

```

好了，我们运行一下效果图

![](http://obyghtd4m.bkt.clouddn.com/weibo4AC4757E-82B3-4134-B3C7-3D71F7B4B6E7.png)



* MainViewController重构

你们有没有发现上面的代码除了类名、标题和图片的名称不一样，其他的都一样，其实很多重复的代码，我们可以使用一个方法把它搞定，而不同的可以通过参数来传递。这个就是简单的`重构`。废话不多说，上代码

```swift
/// 初始化子控制器
///
/// - parameter childController: 需要初始化的子控制器
/// - parameter title:           标题
/// - parameter imageName:       图片
fileprivate func addChildViewController(_ childController: UIViewController, title:String, imageName:String) {
    // 这里提示一下，fileprivate是swift3.0才有的，以前的是使用private

    childController = title
    childController.tabBarItem.image = UIImage(named:imageName)
    childController.tabBarItem.selectedImage = UIImage(named:imageName+"_highlighted")

    // 包装一个导航器
    let navController = UINavigationController()
    navController.addChildViewController(childController)

    // 将导航器添加到当前控制器
    addChildViewController(navController)

}

```

方法构建成功，那么在`viewDidLoad`中使用就非常简单了
```swift

override func viewDidLoad() {
super.viewDidLoad()

    // 设置当前控制器对应tabbar的颜色
    // 注意：在iOS7以前如果设置来了titColor只有文字会变，图片不会变
    tabBar.tintColor = UIColor.orange

    addChildViewController(HomeTableViewController(), title: "首页", imageName: "tabbar_home")
    addChildViewController(MessageTableViewController(), title: "消息", imageName: "tabbar_message_center")
    addChildViewController(DiscoverTableViewController(), title: "广场", imageName: "tabbar_discover")
    addChildViewController(ProfileTableViewController(), title: "我", imageName: "tabbar_profile")

}
```

运行一下，是不是效果一样，然后代码立即少了许多是不是？
![](http://obyghtd4m.bkt.clouddn.com/weibo4AC4757E-82B3-4134-B3C7-3D71F7B4B6E7.png)


## 添加中间按钮

这个按钮比较特殊，所以要特殊处理一下。

首先，我创建一个新的控制器，作为中间按钮的占位控制器
![](http://obyghtd4m.bkt.clouddn.com/weibo7FCEAB0C-D5D4-4B15-87DB-E5859F4F4C70.png)

```swift
addChildViewController("HomeTableViewController", title: "首页", imageName: "tabbar_home")
addChildViewController("MessageTableViewController", title: "消息", imageName: "tabbar_message_center")
// 再添加一个占位控制器
addChildViewController("NullViewController", title: "", imageName: "")
addChildViewController("DiscoverTableViewController", title: "广场", imageName: "tabbar_discover")
addChildViewController("ProfileTableViewController", title: "我", imageName: "tabbar_profile")
```

然后再创建一个按钮表示中间的加号，使用懒加载的方式创建加号按钮
```swift
fileprivate lazy var composeBtn:UIButton = {
    let button = UIButton()

    // 设置前置图片
    button.setImage(UIImage(named:"tabbar_compose_icon_add"), for: UIControlState.normal)
    button.setImage(UIImage(named:"tabbar_compose_icon_add_highlighted"), for: UIControlState.highlighted)

    // 设置背景图片
    button.setBackgroundImage(UIImage(named:"tabbar_compose_button"), for: UIControlState.normal)
    button.setBackgroundImage(UIImage(named:"tabbar_compose_button_highlighted"), for: UIControlState.highlighted)

    // 添加监听事件
    button.addTarget(self, action: #selector(MainViewController.composeBtnClick), for: UIControlEvents.touchUpInside)

    return button

}()
```

注意按钮的函数绑定是`#selector`不是`@selector`,所以这里绑定一个函数，这里有个注意的地方：监听加号按钮点击，监听按钮点击方法不能私有， 按钮点击事件的调用是由  运行循环 监听并且以消息机制传递的，因此，按钮监听函数不能设置为fileprivate
```swift
/// 监听加好按钮点击，注意：监听按钮点击方法不能私有
/// 按钮点击事件的调用是由  运行循环 监听并且以消息机制传递的，因此，按钮监听函数不能设置为`fileprivate`
func composeBtnClick() {
    print(#function)
    print("点击按钮")
}
```

再把加号按钮添加到tababr上，这里我抽成一个函数，顺便调整加号按钮的frame
```swift
fileprivate func addComposeButton(){

    // 添加按钮
    tabBar.addSubview(composeBtn)

    // 调整加好按钮的位置
    print("\((viewControllers?.count)! + 1)")
    let width = UIScreen.main.bounds.size.width / CGFloat(viewControllers!.count)
    let rect = CGRect(x: 0, y: 0, width: width, height: 49)

    composeBtn.frame = rect.offsetBy(dx: 2 * width, dy: 0)

}
```

一般都是在`viewDidLoad`这里添加并在设置`frame`，我也这么一直认为，但是我在`viewDidLoad`打印一下`print(tabBar.subviews)`，发现是空的，而在`viewWillAppear`打印却有值并且有`frame`。`从iOS7开始就不推荐大家在viewDidLoad中设置frame`，所以在`viewWillAppear`添加加号按钮
```swift
override func viewWillAppear(_ animated: Bool) {
super.viewWillAppear(animated)

//        print("-----")
//        print(tabBar.subviews)
    // 有值，有frame
    addComposeButton()
}
```
好了，运行一下看看效果。

![](http://obyghtd4m.bkt.clouddn.com/weibo26198C0D-96FF-4761-A63F-A6EF26D00B73.png)







































