//
//  Date-Extension.swift
//  WeiBo
//
//  Created by AISION on 17/3/9.
//  Copyright © 2017年 xiaokai.wang. All rights reserved.
//

import Foundation
extension Date{
    static func createDateString(createAt : String) -> String{
        //1.创建时间格式对象
        let fmt = DateFormatter()
        fmt.dateFormat = "EEE MM dd HH:mm:ss Z yyyy"
        fmt.locale = Locale(identifier: "en")
        // 2,将字符串时间转成NSDate类型
        guard let createDate = fmt.date(from: createAt) else{
            return ""
        }
        
        // 3. 创建当前时间
        let nowDate = Date()
        //4.计算创建时间和当前时间的时间差
        let interval = Int( nowDate.timeIntervalSince(createDate))
        
        // 5.对时间间隔的处理
        //5.1显示刚刚
        if interval < 60{
            print("刚刚")
            return "刚刚"
        }
        // 5.2 59分钟前
        if interval < 60 * 60{
            print("\(interval / 60)分钟前")
            return "\(interval / 60)分钟前"
        }
        // 5.3 11小时前
        if interval < 60 * 60 * 24{
            print("\(interval / (60 * 60))小时前")
            return "\(interval / (60 * 60))小时前"
        }
        //5.4创建日历对象
        let calendar = Calendar.current
        //5.5处理昨天的数据: 昨NCCS23
        if calendar.isDateInYesterday(createDate){
            fmt.dateFormat = "昨天 HH:mm"
            let timeStr = fmt.string(from: createDate)
            print(timeStr)
            return timeStr
        }
        //5.6 处理一年之内：02-22 12：22
        let cmps = calendar.component(.year, from: createDate)
        if cmps < 1 {
            fmt.dateFormat = "MM-dd HH:mm"
            let timeStr = fmt.string(from: createDate)
            return timeStr
            
        }
        //5.7超过一年：2014-02-12 13：22
        fmt.dateFormat = "yyyy-MM-dd HH:mm"
        let timeStr = fmt.string(from: createDate)
        return timeStr
        

        
    }
}
