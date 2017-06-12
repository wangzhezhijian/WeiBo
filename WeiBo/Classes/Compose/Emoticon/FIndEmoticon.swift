//
//  FIndEmoticon.swift
//  WeiBo
//
//  Created by AISION on 17/5/31.
//  Copyright © 2017年 xiaokai.wang. All rights reserved.
//

import UIKit

class FIndEmoticon: NSObject {
    // MARK : -设计单例对象
    static let shareIntance : FIndEmoticon = FIndEmoticon()
    
    // MARK : -- 表情属性
    fileprivate lazy var manager : EmoticonManager = EmoticonManager()
    // 查找属性字符串的方法
    func findAttString(statusText : String?, font : UIFont) -> NSMutableAttributedString? {
        // 0. 如果statusText 没有则返回空
        guard let statusText = statusText else {
            return nil
        }
        // 1. 创建匹配规则
        let pattern = "\\[.*?\\]"// 匹配规则
        // 2.创建正则表达式对象
        guard let regex  = try? NSRegularExpression(pattern: pattern, options: []) else{
            return nil
        }
        // 3. 开始匹配
        let results = regex.matches(in: statusText, options: [], range: NSRange(location: 0, length: statusText.characters.count))
        // 4. 获取结果
        let attrMStr = NSMutableAttributedString(string: statusText)
       
       
        for (index,_) in results.enumerated().reversed() {
            //4.0 获取结果
            let result = results[index]
            // 4. 获取chs
            let chs = (statusText as NSString).substring(with: result.range)
            // 4.2 根据chs，获取图片的路径
            guard let pngPath = findPngPath(chs: chs) else {
                return nil
            }
            // 4.3 创建属性字符串
            let attachment = NSTextAttachment()
            attachment.image = UIImage(contentsOfFile: pngPath)
            let font = font
            attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
            let attrImageStr = NSAttributedString(attachment: attachment)
            // 4.4 将属性字符串替换到来源的文字位置
            attrMStr.replaceCharacters(in: result.range, with: attrImageStr)
        }
        // 返回结果
        return attrMStr
        
    }
    fileprivate func findPngPath(chs : String) -> String?{
        for package in manager.packages{
            for emoticon in package.emoticons{
                if emoticon.chs == chs{
                    return emoticon.pngPath
                }
            }
            
        }
        return nil
    }
}


