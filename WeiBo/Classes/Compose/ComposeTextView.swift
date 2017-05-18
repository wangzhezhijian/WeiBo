//
//  ComposeTextView.swift
//  WeiBo
//
//  Created by AISION on 17/5/17.
//  Copyright © 2017年 xiaokai.wang. All rights reserved.
//

import UIKit

class ComposeTextView: UITextView {

    // MARK:--懒加载属性
    lazy var placeHolderLabel : UILabel = UILabel()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
  
}
// MARK:--设置UI界面
extension ComposeTextView{
   fileprivate func setupUI(){
        // 1.添加子控件
        addSubview(placeHolderLabel)
        //2. 设置frame
        placeHolderLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(8)
            make.left.equalTo(10)
        }
        // 3.设置placeholderLabel 的属性
        placeHolderLabel.textColor = UIColor.lightGray
        placeHolderLabel.font = font
        
        // 4.设置plac文字
        placeHolderLabel.text = "分享新鲜事"
        // 设置内容的内边距
        textContainerInset = UIEdgeInsetsMake(7, 7, 0, 7)
    }
}
extension ComposeTextView{
    
}
