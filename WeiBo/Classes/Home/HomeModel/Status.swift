//
//  Status.swift
//  WeiBo
//
//  Created by AISION on 17/3/8.
//  Copyright © 2017年 xiaokai.wang. All rights reserved.
//

import UIKit

class Status: NSObject {
    // MARK:--属性
    var created_at : String? //微博创建时间
    var source : String? // 微博来源
    var text : String? //文本
    var mid : Int = 0 //微博id
    var user : User? //
    var pic_urls : [[String:String]]? //微博配图
    var retweeted_status : Status? //微博对应的转发的微博
    
   
    // MARK : -自定义构造函数
    init(dict : [String : AnyObject]) {
        super.init()
        setValuesForKeys(dict)
        //1.将用户字典转成用户模型对象
        if let userDict = dict["user"] as? [String : AnyObject]{
            user = User(dict: userDict)
        }
        //2. 将转发微博字典转成微博模型对象
        if let retweetedStatusDict = dict["retweeted_status"] as? [String : Any]{
            retweeted_status = Status(dict : retweetedStatusDict as [String : AnyObject])
        }
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
