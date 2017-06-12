//
//  UIButton-backImage.swift
//  WeiBo
//
//  Created by AISION on 17/2/27.
//  Copyright © 2017年 xiaokai.wang. All rights reserved.
//

import UIKit

extension UIButton{
    // swift 中类方法是以class 开头的，类似于oc中以+开头的
  /*  class func createButton(imageName : String, bgImageName : String) -> UIButton{
        // 1.创建Btn
        let btn = UIButton()
        // 2.设置btn的属性
        btn.setImage(UIImage(named: imageName), for: .normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        btn.setBackgroundImage(UIImage(named: bgImageName), for: .normal)
        btn.setBackgroundImage(UIImage(named: bgImageName), for: .highlighted)
        return btn
    }
 */
    // convenience : 便利，使用convenience修饰的构造函数叫做便利构造函数
    // 便利构造函数通常用在对系统的类进行构造函数的扩充时使用
    /*
        1. 便利构造函数通常写在extension
        2. 便利构造函数init 前面需要加载convenience
        3.在便利构造函数中必须写self.init()
     */
    convenience init(imageName: String,bgImageName: String) {
        self.init()
        setImage(UIImage(named: imageName), for: .normal)
        setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        setBackgroundImage(UIImage(named: bgImageName), for: .normal)
        setBackgroundImage(UIImage(named: bgImageName + "_highlighted"), for: .highlighted)
        sizeToFit()
    }
    convenience init(bgColor : UIColor,fontSize : CGFloat,title : String ) {
        self.init()
        setTitle(title, for: .normal)
        backgroundColor = bgColor
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
    }
}
