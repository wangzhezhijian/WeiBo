//
//  UserAccountTool.swift
//  WeiBo
//
//  Created by AISION on 17/3/8.
//  Copyright © 2017年 xiaokai.wang. All rights reserved.
//

import UIKit

class UserAccountViewModel: NSObject {
    
    // MARK:--将类设计成单例
    static let shareIntance : UserAccountViewModel = UserAccountViewModel()
    
    var account : UserAccount?
    
    var accountPath : String {
        var accountPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        accountPath.append("/account.plist")
        return accountPath
    }
      //MARK--重写init()函数
    override init() {
        super.init()
        // 1.先从沙盒中读取归档信息
       
        // 1.2 读取信息
        account = NSKeyedUnarchiver.unarchiveObject(withFile:accountPath) as? UserAccount
    }
    
    func isLogin() -> Bool {
        if account == nil {
            return false
        }
        guard let expiresDate = account?.expire_date else {
            return false
        }
        return expiresDate.compare(Date()) == ComparisonResult.orderedDescending
    }
}
