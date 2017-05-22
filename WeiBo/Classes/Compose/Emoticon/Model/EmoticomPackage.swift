//
//  EmoticomPackage.swift
//  WeiBo
//
//  Created by AISION on 17/5/22.
//  Copyright © 2017年 xiaokai.wang. All rights reserved.
//

import UIKit

class EmoticomPackage: NSObject {
    var emoticons : [Emoticon] = [Emoticon]()
    
     init(id : String) {
        super.init()
        //1.
        
        if  id == ""{
            // 5. 添加空白ge
           addEmptyEmoticon(isRecently: true)
            return
        }
        //2.根据id拼接info.plist 的路径
        let plistPath = Bundle.main.path(forResource: "\(id)/info.plist", ofType: nil, inDirectory: "Emoticons.bundle")!
        // 3. 根据plist文件来读取数据
        let array = NSArray(contentsOfFile: plistPath)! as! [[String : String]]
        // 4. 遍历数组
        var index = 0
        for var dict in array{
            if let png = dict["png"] {
              dict["png"] =  id + "/" + png
            }
            emoticons.append(Emoticon(dict: dict))
            index += 1
            if index == 20{
                // 添加删除表情
                emoticons.append(Emoticon(isRemove : true))
                index = 0
                
            }
        }
        // 5. 添加空白ge
        addEmptyEmoticon(isRecently: false)
    }
   fileprivate func addEmptyEmoticon(isRecently : Bool){
        
        let count = emoticons.count % 21
        if count == 0 && !isRecently {
            return
        }
        for _ in count..<20{
            emoticons.append(Emoticon(isEmpty : true))
        }
         emoticons.append(Emoticon(isRemove : true))
        
    }
}
