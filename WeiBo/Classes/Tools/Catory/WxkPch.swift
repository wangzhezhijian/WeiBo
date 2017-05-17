//
//  WxkPch.swift
//  WeiBo
//
//  Created by AISION on 17/3/1.
//  Copyright © 2017年 xiaokai.wang. All rights reserved.
//

import UIKit

///屏幕 高度
let ScreenH = UIScreen.main.bounds.height
///屏幕高度
let ScreenW = UIScreen.main.bounds.width


///判断是否是6p
let iPhone6Push:Bool = UIScreen.main.bounds.width == 414 ?  true : false
///判断是否是6
let iPhone6:Bool = UIScreen.main.bounds.width == 375 ?  true : false
///判断是否是5s 5e 4s
let iPhone5s5e4s = iPhone6 != true && iPhone6Push != true ? true : false
// MARK:--授权的常量
let app_key = "2148581756"
let app_secret = "0ca2dd994d058c04938972f2775878ae"
let redirect_uri = "https://github.com/wangzhezhijian/WeiBo"


