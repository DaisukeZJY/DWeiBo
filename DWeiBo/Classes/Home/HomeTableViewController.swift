//
//  HomeTableViewController.swift
//  DWeiBo
//
//  Created by DaiSuke on 2016/10/27.
//  Copyright © 2016年 DaiSuke. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh

// cell的标志
let kHomeCellReuseIdentifier = "kHomeCellReuseIdentifier"

class HomeTableViewController: BaseViewController {
    
    // 保存微博数组
    var statuses: [Status]? {
        didSet{
            // 设置数据完毕，刷新表格
            tableView.reloadData()
        }
    }
    
    /// 微博行高的缓存，利用字典作为容器，key是微博的ID，值就是对应微博的行高
    var rowCache: [Int:CGFloat] = [Int:CGFloat]()
    
    override func didReceiveMemoryWarning() {
        // 清空缓存
        rowCache.removeAll()
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
        
        view.addSubview(tableView)
        
        tableView.xmg_Fill(view, insets: UIEdgeInsetsMake(navHeight, 0, tabbarHeight, 0))
        
//        tableView.frame = CGRect(x: 0, y: navHeight, width: view.frame.size.width, height: view.frame.size.height - tabbarHeight - navHeight)
        
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
    
    /// 定义变量记录当时上拉还是下拉
    var pullupRefreshFalg = false
    
    /// 加载数据
    private func loadData() {
        /*
         1、默认最新返回20条数据
         2、since_id: 会返回比since_id大的微博
         3、max_id:会返回小鱼等于max_id的微博
         
         每条微博都有一个微博id,而且微博ID越后面发送的微博，他的微博ID越大
         */
        
        var since_id = statuses?.first?.id ?? 0
        var max_id = 0
        // 判断是否上拉
        if pullupRefreshFalg {
            since_id = 0
            max_id = statuses?.last?.id ?? 0
        }
        
        
        weak var weakSelf = self
        Status.loadStatuses(since_id:since_id, max_id:max_id) { (models, error) in
            
            weakSelf?.tableView.mj_header.endRefreshing()
            weakSelf?.tableView.mj_footer.endRefreshing()
            if error != nil {
                SVProgressHUD.showError(withStatus: "服务器错误")
                return
            }
            
            if since_id > 0 {
                // 下拉刷新
                weakSelf?.statuses = models! + (weakSelf?.statuses!)!
                
                // 显示刷新提醒
                weakSelf?.showNewStatusCount(count: models?.count ?? 0)
            } else if max_id > 0 {
                // 如果是上拉加载更多，将数据取到的数据拼在原有的数据后面
                weakSelf?.statuses = (weakSelf?.statuses!)! + models!
            } else {
                weakSelf?.statuses = models
            }
        }
    }
    
    private func showNewStatusCount(count:Int){
        newStatusLabel.isHidden = false
        newStatusLabel.text = (count == 0) ? "没有刷新到新的微博数据" : "已更新\(count)条数据"
        UIView.animate(withDuration: 2, animations: {
            self.newStatusLabel.transform = CGAffineTransform(translationX: 0, y: self.newStatusLabel.frame.size.height)
        }) { (finish) in
            UIView.animate(withDuration: 2, animations: {
                self.newStatusLabel.transform = CGAffineTransform.identity
            }, completion: { (_) in
                self.newStatusLabel.isHidden = true
            })
        }
    }
    
    private lazy var newStatusLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.orange
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44)
        // 加到导航栏上
        self.navigationController?.navigationBar.insertSubview(label, at: 0)
        label.isHidden = true
        return label
    }()
    
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        view.dataSource = self
        view.delegate = self;
        // 注册cell
        view.register(StatusTableViewCell.self, forCellReuseIdentifier: StatusTableViewCellIdentifier.NormalCell.rawValue)
        view.register(StatusTableViewCell.self, forCellReuseIdentifier: StatusTableViewCellIdentifier.ForwardCell.rawValue)
        view.separatorStyle = UITableViewCellSeparatorStyle.none
        weak var weakSelf = self
        view.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            weakSelf?.pullupRefreshFalg = false
            weakSelf?.loadData()
        })
        view.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            weakSelf?.pullupRefreshFalg = true
            weakSelf?.loadData()
        })
        view.mj_header.beginRefreshing()
        return view
    }()
    
    
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


extension HomeTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let status = statuses![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: StatusTableViewCellIdentifier.cellID(status: status), for: indexPath) as! StatusTableViewCell
        cell.status = status
        return cell

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 取出对应的模型
        let status = statuses![indexPath.row]
        // 判断缓存中有没有
        if let height = rowCache[status.id] {
            return height
        }
        
        // 拿到cell
        //        let cell = tableView.dequeueReusableCell(withIdentifier: kHomeCellReuseIdentifier) as! StatusTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: StatusTableViewCellIdentifier.cellID(status: status)) as! StatusTableViewCell
        
        // 拿到行高
        let rowHeight = cell.rowHeight(status: status)
        // 缓存行高
        rowCache[status.id] = rowHeight
        return rowHeight

    }
  
}

