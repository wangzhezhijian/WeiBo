//
//  EmoticonManager.swift
//  WeiBo
//
//  Created by AISION on 17/5/22.
//  Copyright © 2017年 xiaokai.wang. All rights reserved.
//

import UIKit

class EmoticonManager: NSObject {
    var packages : [EmoticomPackage] = [EmoticomPackage]()
    override init() {
        // 1.添加最近的表情包
        packages.append(EmoticomPackage(id : ""))
        // 2.添加默认表情包
         packages.append(EmoticomPackage(id : "com.sina.default"))
        // 3.添加emoji表情包
         packages.append(EmoticomPackage(id : "com.apple.emoji"))
        // 4.添加浪小花表情包
         packages.append(EmoticomPackage(id : "com.sina.lxh"))
        
    }
}
