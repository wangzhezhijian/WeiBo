//
//  WxkPresentationController.swift
//  WeiBo
//
//  Created by AISION on 17/3/1.
//  Copyright © 2017年 xiaokai.wang. All rights reserved.
//

import UIKit

class WxkPresentationController: UIPresentationController {
    
    var presentedFrame : CGRect = .zero
    //MARK:--懒加载
    lazy var coverView : UIView = UIView()
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        // 设置弹出View 的尺寸
        presentedView?.frame = presentedFrame
        
        // 2.添加蒙版
        setupCoverView()
    }
}
// 设置UI界面
extension WxkPresentationController{
    func setupCoverView(){
        // 1.添加蒙版
        containerView?.insertSubview(coverView, at: 0)
        // 设置蒙版的属性
        coverView.backgroundColor = UIColor(white: 0.8, alpha: 0.2)
        coverView.frame = containerView!.bounds
        // 3. 添加手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(WxkPresentationController.coverViewClick))
        coverView.addGestureRecognizer(tap)
    }
}
// 事件监听
extension WxkPresentationController{
    func coverViewClick() {
        presentedViewController .dismiss(animated: true) { 
            
        }
    }
}
