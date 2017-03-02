//
//  HomeViewController.swift
//  WeiBo
//
//  Created by AISION on 17/2/7.
//  Copyright © 2017年 xiaokai.wang. All rights reserved.
//

import UIKit

class HomeViewController : BaseViewController {
    
    
    //MARK:--懒加载属性
    lazy var titleBtn : TitleButton = TitleButton()
    
    //注意：在闭包中如果使用当前对象的属性或者调用方法，也需要加self
    //两个地方需要使用self:1>如果一个函数出现歧义 2> 在闭包中使用当前对象的属性
    lazy var popoverAnimator : PopoverAnimator = PopoverAnimator { [weak self](presented)->() in
        self?.titleBtn.isSelected = presented
    }
    //MARK:--系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        visitorView.addRotationAnim()
        // 1.没有登录时设置的内容
        if !isLogin{
            return
        }
        //2.设置导航栏的内容
        setupNavigationBar()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }


}
//MARK:--设置UI界面
extension HomeViewController{
    //1. 设置左侧的Item
    func setupNavigationBar(){
        //1.设置左侧的Item
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention")
        
        // 2.设置右侧的Item
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName:"navigationbar_pop")
        // 3. 设置titleView
       
        titleBtn.setTitle("哈哈哈", for: .normal)
        titleBtn.addTarget(self, action:#selector(titleBtnClick), for: .touchUpInside)
       
        navigationItem.titleView = titleBtn
        
    }
    
}
//MARK:--NAV Title 点击事件
extension HomeViewController{
   
   @objc func titleBtnClick(){
    
    
        // 1.创建弹出的控制器
        let popoverVc = PopoverViewController()
        popoverVc.modalPresentationStyle = .custom
        // 2.设置转场的代理
        popoverVc.transitioningDelegate = popoverAnimator
        popoverAnimator.presentedFrame = CGRect(x: ScreenW/2-75, y: 60, width: 150, height: 250)
        //3.弹出控制器
        present(popoverVc, animated: true) { 
            
        }
    
    
    }

}

