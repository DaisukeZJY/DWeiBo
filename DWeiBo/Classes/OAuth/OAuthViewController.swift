//
//  OAuthViewController.swift
//  DWeiBo
//
//  Created by DaiSuke on 2018/5/7.
//  Copyright © 2018年 DaiSuke. All rights reserved.
//

import UIKit

class OAuthViewController: UIViewController {

    let kAppKey = "2282898180"
    let kAppSecret = "b20d4256187f91e14aa627deaff67528"
    let kRedirectUrl = "http://daisuke.cn"
    
    override func loadView() {
        view = webView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationItem.title = "授权"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.plain, target: self, action: #selector(close))
        
        // 获取未授权的RequestToken
        // 要求SSL1.2
        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=\(kAppKey)&redirect_uri=\(kRedirectUrl)"
        let url = NSURL(string: urlStr)
        let request = NSURLRequest(url: url! as URL)
        webView.loadRequest(request as URLRequest)
        
    }
    
    func close() {
        dismiss(animated: true, completion: nil)
    }
    

    lazy var webView: UIWebView = {
        let webView = UIWebView()
        webView.delegate = self
        return webView
    }()
}


extension OAuthViewController: UIWebViewDelegate{
    
    // 返回true正常加载，返回false不加载
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        // 判断是否授权回调页面，如果不是继续加载
        let urlStr = request.url!.absoluteString
        if !urlStr.hasPrefix(kRedirectUrl) {
            // 继续加载
            return true
        }
        
        // 判断是否授权
        let codeStr = "code="
        if request.url!.query!.hasPrefix(codeStr) {
            // 授权成功
            // 取出已经授权的RequestToken
            let code = request.url!.query!.substring(from: codeStr.endIndex)
            
            // 利用已经授权的RequestToken换取AccessToken
            loadAccessToken(code: code)
        }
        
        
        return false
    }
    
    /// 换取AccessToken
    private func loadAccessToken(code:String) {
        // 定义路径
        let path = "oauth2/access_token"
        // 封装参数
        let params = ["client_id":kAppKey, "client_secret":kAppSecret, "grant_type":"authorization_code", "code":code, "redirect_uri":kRedirectUrl]
        
        NetworkTools.shareNetworkTools().post(path, parameters: params, progress: { (_) in
            
        }, success: { (_, json) in
            print(json as Any)
            let user = UserAccount(dict: json as! [String : AnyObject])
            print(user)
            
            
        }) { (_, error) in
            print(error)
        }
        
    }
    
}














