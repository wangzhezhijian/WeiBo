//
//  MainViewController.swift
//  WeiBo
//
//  Created by AISION on 17/2/7.
//  Copyright © 2017年 xiaokai.wang. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildViewController(childVc: HomeViewController(), title: "首页", imageName: "tabbar_home")
        addChildViewController(childVc: MessageViewController(), title: "消息", imageName: "tabbar_message_center")
        addChildViewController(childVc: DiscoverViewController(), title: "发现", imageName: "tabbar_discover")
        addChildViewController(childVc: ProfileViewController(), title: "我的", imageName: "tabbar_profile")
        
        
    }

    
    // swift 支持方法的重载
    // 方法的名称相同，但是参数不同，1.参数的类型不同，2，参数的个数不同
    // private 在当前文件中可以访问，但是其他文件不能访问
   private func addChildViewController(childVc: UIViewController,title : String,imageName : String) {
    // 1. 创建子控制器
    
    // 2. 设置子控制器的属性
    childVc.view.backgroundColor = UIColor.yellow
    childVc.title = title
    childVc.tabBarItem.image = UIImage(named: imageName)
    childVc.tabBarItem.selectedImage = UIImage(named: imageName + "highlighted")
    
    
    // 3.包装导航控制器
    let childNav = UINavigationController(rootViewController : childVc)
    
    // 4.添加控制器
    addChildViewController(childNav)

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
