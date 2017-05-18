//
//  ComposeTitleView.swift
//  WeiBo
//
//  Created by AISION on 17/5/17.
//  Copyright © 2017年 xiaokai.wang. All rights reserved.
//

import UIKit
import SnapKit
class ComposeTitleView: UIView {

    //MARK:-- 懒加载属性
    lazy var titleLabel : UILabel = UILabel()
    lazy var screenNameLabel : UILabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
// MARK: --设置UI界面
extension ComposeTitleView{
    func setupUI(){
        addSubview(titleLabel)
        addSubview(screenNameLabel)
        
        // 2. 设置frame
      
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self)
            make.top.equalTo(self)
        }
        screenNameLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(titleLabel.snp.centerX)
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
        }
        // 3. 设置空间的属性
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        screenNameLabel.font = UIFont.systemFont(ofSize: 14)
        screenNameLabel.textColor = UIColor.lightGray
        
        // 设置文字内容
        titleLabel.text = "微博"
        screenNameLabel.text = UserAccountViewModel.shareIntance.account?.screen_name
    }
}
