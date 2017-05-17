//
//  OAuthViewController.swift
//  WeiBo
//
//  Created by AISION on 17/3/3.
//  Copyright © 2017年 xiaokai.wang. All rights reserved.
//

import UIKit
import SVProgressHUD
class OAuthViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavigator()
        
        // 2. 加载网页
        
       loadPage()
    }

  
    

}
extension OAuthViewController{
    func setupNavigator()  {
        // 1. 设置左侧的item
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(OAuthViewController.closeItemClick))
        // 2. 设置右侧的item
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "填充", style: .plain, target: self, action: #selector(OAuthViewController.fillItemClick))
        // 3.设置标题
        title = "登录界面"
    }
    
    func loadPage()  {
        // 1.获取登陆界面的URLString
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(app_key)&redirect_uri=\(redirect_uri)"
        // 2.创建对应URL
        guard let url = URL(string: urlString) else {
           return
        }
        // 3.创建URLRequest 对象
        let request = URLRequest(url: url)
        // 4.加载request 对象
        webView.loadRequest(request)
        
    }
}
//MARK:--事件监听函数
extension OAuthViewController{
    func closeItemClick()  {
        dismiss(animated: true, completion: nil)
    }
    func fillItemClick(){
        // 1. 书写js代码JavaScript
        let jsCode = "document.getElementById(\"userId\").value = \"1581076072@qq.com\";document.getElementById(\"passwd\").value = \"wangxiaokai2017\";"
        // 执行js代码
        webView.stringByEvaluatingJavaScript(from: jsCode)
    }
}
//MARK:--webView的delegate
extension OAuthViewController : UIWebViewDelegate{
    // webView 开始加载网页
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        SVProgressHUD.dismiss()
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        SVProgressHUD.dismiss()
    }
    // 当准备加载某一个页面时会执行该方法
    // 返回值 : true ->继续加载该页面 false -> 不会加载该页面
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print(request.url)
        // 1. 获取加载网页url
        guard let url = request.url else {
            return true
        }
        // 2.获取url 中的字符串
        let urlString = url.absoluteString
        // 3.判断该字符串中是否包含code
        guard urlString.contains("code=") else {
            return true
        }
        // 4.将code 截取出来
       let code = urlString.components(separatedBy: "code=").last!
        
        // 请求accessToken
        loadAccessToken(code: code)
        
        return false
        
        
        
        
       
    }
}

extension OAuthViewController{
    // 请求AccessToken
    func loadAccessToken(code : String)  {

        NetworkTools.shareInstance.loadAccessToken(code: code) { (result, error) in
//             1. 错误校验
            if error != nil{
                print(error)
                return
            }
            // 2.拿到结果
            print(result )

            guard let accountDict = result else{
                print("没有获取授权后的数据")
                return
            }
            // 3. 将我们的字典转成模型对象
            let account = UserAccount(dict: accountDict)
            print(account.description)
            
            // 4. 请求用户信息
            self.loadUserInfo(account: account)
        }
    }
    // 请求用户信息
    func loadUserInfo(account : UserAccount)  {
        
        // 1.获取AccessToken
        guard let accessToken = account.access_token else{
            return
        }
        // 2.获取Uid
        guard let uid = account.uid else {
            return
        }
        // 3. 发送网络请求
        NetworkTools.shareInstance.loadUserInfo(access_token: accessToken, uid: uid) { (result, error) in
            if error != nil{
                print(error!)
                return
            }
            // 2. 拿到用户信息的结果
            guard let userInfoDict = result else{
                return
            }
            print(userInfoDict)
            // 3. 从字典中取出昵称和用户头像地址
            
            account.screen_name = userInfoDict["screen_name"] as? String
            account.avatar_large = userInfoDict["avatar_large"] as? String
            // 4.将account 对象保存（归档，解档）
            // 4.2保存对象
            
            NSKeyedArchiver.archiveRootObject(account, toFile: UserAccountViewModel.shareIntance.accountPath)
            // 4.3 将account 对象设置到单例对象中
            UserAccountViewModel.shareIntance.account = account
            
            // 5. 显示欢迎界面(先退出当前控制器)
           self.dismiss(animated: false, completion: {
            () -> Void in
                UIApplication.shared.keyWindow?.rootViewController = WelcomeViewController()
           })
            
        }
    }
    
}

