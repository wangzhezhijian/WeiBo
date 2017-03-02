//
//  VisitorView.swift
//  WeiBo
//
//  Created by AISION on 17/2/28.
//  Copyright © 2017年 xiaokai.wang. All rights reserved.
//

import UIKit

class VisitorView: UIView {

    // MARK:--提供快速通过xib的创建的类方法
    class func visitorView() -> VisitorView {
        return Bundle.main.loadNibNamed("VisitorView", owner: nil, options: nil)?.first as! VisitorView
    }
    //MARK:--控件的属性
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var rotationView: UIImageView!
    
    @IBOutlet weak var registerBtn: UIButton!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    // MARK:--自定义函数
    func setupVisitorViewInfo(iconName :  String,title : String){
        iconView.image = UIImage(named : iconName)
        tipLabel.text = title
        rotationView.isHidden = true
    }
    // MARK:--首页动画
    func addRotationAnim() {
        // 1. 创建动画
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        // 2. 设置动画的属性
        rotationAnim.fromValue = 0
        rotationAnim.toValue = M_PI*2
        rotationAnim.repeatCount = MAXFLOAT
        rotationAnim.duration = 3
        rotationAnim.isRemovedOnCompletion = false
        // 3.将动画添加到layer中
        rotationView.layer.add(rotationAnim, forKey: nil)
    }
}
