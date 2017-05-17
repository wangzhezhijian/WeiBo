//
//  UserAccount.swift
//  WeiBo
//
//  Created by AISION on 17/3/6.
//  Copyright © 2017年 xiaokai.wang. All rights reserved.
//

import UIKit

class UserAccount: NSObject,NSCoding {
    // MARK--属性
    // 授权accessToken
    var access_token : String?
    // 过期时间
    var expires_in : TimeInterval = 0.0{
        didSet{
            expire_date = Date(timeIntervalSinceNow: expires_in + 8*60*60)
            
        }
    }
    // 用户id
    var uid : String?
    
    //过期日期处理
    var expire_date : Date?
    
    // 用户昵称
    var screen_name : String?
    // 用户头像
    var avatar_large : String?
    //MARK:--自定义构造函数
    init(dict : [String : AnyObject]){
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    override var description: String{
        return dictionaryWithValues(forKeys: ["access_token","expire_date","uid","screen_name","avatar_large"]).description
    }
    // MARK:--归档解档
    required init?(coder aDecoder: NSCoder) {
       access_token = aDecoder.decodeObject(forKey: "access_token") as? String
        uid = aDecoder.decodeObject(forKey: "uid") as? String
        expire_date = aDecoder.decodeObject(forKey: "expire_date") as? Date
        avatar_large = aDecoder.decodeObject(forKey: "avatar_large") as? String
        screen_name = aDecoder.decodeObject(forKey: "screen_name") as? String
        
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(expire_date, forKey: "expire_date")
        aCoder.encode(avatar_large, forKey: "avatar_large")
        aCoder.encode(screen_name, forKey: "screen_name")
    }
}
