//
//  UIBarButtonItem-Extension.swift
//  WeiBo
//
//  Created by AISION on 17/2/28.
//  Copyright © 2017年 xiaokai.wang. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    convenience init(imageName : String) {
        self.init()
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), for: .normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        btn.sizeToFit()
        self.customView = btn
    }
}
