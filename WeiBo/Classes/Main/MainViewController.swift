//
//  MainViewController.swift
//  WeiBo
//
//  Created by AISION on 17/2/7.
//  Copyright © 2017年 xiaokai.wang. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    
    //MARK:--懒加载属性
     lazy var imageNames = ["tabbar_home","tabbar_message_center","","tabbar-discover","tabbar_profile"];
     lazy var composeBtn : UIButton = UIButton(imageName: "tabbar_compose_icon_add", bgImageName: "tabbar_compose_button")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupComposeBtn(composeBtn: composeBtn)
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//       setupTabbarItems()
    }
}
extension MainViewController{
    ///设置发布按钮
     func setupComposeBtn(composeBtn : UIButton){
        //1. 将composeBtn 添加到tabbar中
        tabBar.addSubview(composeBtn)
        composeBtn.center = CGPoint(x : tabBar.center.x, y : tabBar.bounds.size.height*0.5)
        // 2.监听发布按钮的点击
        composeBtn.addTarget(self, action: #selector(MainViewController.composeBtnClick), for: .touchUpInside)
    }
    
//    /// 调整tabbar 中的item
//    func setupTabbarItems(){
//        // 1.遍历所有的item
//        for i in 0..<tabBar.items!.count{
//            // 2.获取item
//            let item = tabBar.items![i]
//            // 3.如果是下标值为2，则该item 不可以和用户交互
//            if i == 2{
//                item.isEnabled = false
//                continue
//            }
//            // 4. 设置其他item 的选中时候的图片
//            item.selectedImage = UIImage(named:imageNames[i] + "_highlighted")
//        }
//        
//        
//    }

}
extension MainViewController{
    // 事件监听 本质是发送消息 swift 没有发送消息特性
    // 过程： 将方法包装成SEL--> 类中查找方法列表 --> 根据@SEL 找到imp指针(函数指针)--> 执行函数
    // private 声明的话，那么该函数不会被添加到方法列表中
   func composeBtnClick(){
         
    }
}
