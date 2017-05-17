//
//  BaseViewController.swift
//  WeiBo
//
//  Created by AISION on 17/2/28.
//  Copyright © 2017年 xiaokai.wang. All rights reserved.
//

import UIKit

class BaseViewController: UITableViewController {

    
        // MARK:--懒加载属性
        lazy var visitorView : VisitorView = VisitorView.visitorView()
        //MARK:--定义变量
        var isLogin : Bool = UserAccountViewModel.shareIntance.isLogin()
        
        // MARK:--系统回调函数
        override func loadView() {
            
            // 1.先从沙盒中读取归档信息
           
            // 判断要加载哪一个View
            
            isLogin ? super.loadView() : setupVisitorView()
        }
        override func viewDidLoad() {
            super.viewDidLoad()
            setupUI()
        }
}

extension BaseViewController{
        func setupVisitorView(){
            view = visitorView
            // 监听视图中“注册”和“登录" 按钮的点击
            visitorView.registerBtn.addTarget(self,action: #selector(BaseViewController.registerBtnClick),for: .touchUpInside)
            visitorView.loginBtn.addTarget(self, action: #selector(BaseViewController.loginBtnClick), for: .touchUpInside)
        }
    
    
    //MARK:--设置UI界面
    func setupUI() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action:#selector(BaseViewController.registerBtnClick));
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(BaseViewController.loginBtnClick))
    }
}

extension BaseViewController{
    func registerBtnClick() {
        
    }
    func loginBtnClick(){
        // 1.创建授权控制器
        let oauthVc = OAuthViewController()
        
        // 2. 包装导航控制器
        let oauthNav = UINavigationController(rootViewController : oauthVc)
        // 3.弹出控制器
        present(oauthNav, animated: true, completion: nil)
    }
}



