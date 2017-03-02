//
//  TitleButton.swift
//  WeiBo
//
//  Created by AISION on 17/2/28.
//  Copyright © 2017年 xiaokai.wang. All rights reserved.
//

import UIKit

class TitleButton: UIButton {

   override init(frame: CGRect) {
        super.init(frame: frame)
        setImage(UIImage(named: "navigationbar_arrow_down"), for: .normal)
        setImage(UIImage(named: "navigationbar_arrow_up"), for: .selected)
        setTitleColor(UIColor.black, for: .normal)
        sizeToFit()
    }
    // swift 中规定：重写控件的init(frame方法)或者init()方法，必须重写init?
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel!.frame.origin.x = 0
        imageView?.frame.origin.x = titleLabel!.frame.size.width+8
    }
}
