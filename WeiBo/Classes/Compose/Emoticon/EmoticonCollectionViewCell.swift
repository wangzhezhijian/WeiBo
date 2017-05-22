//
//  EmoticonCollectionViewCell.swift
//  WeiBo
//
//  Created by AISION on 17/5/22.
//  Copyright © 2017年 xiaokai.wang. All rights reserved.
//

import UIKit

class EmoticonCollectionViewCell: UICollectionViewCell {
    fileprivate lazy var emoticonBtn : UIButton = UIButton()
    // MARK: 定义属性
    var emoticon : Emoticon?{
        didSet{
            guard let emoticon = emoticon else {
                return
            }
            // 1. 设置emoticonBtn的内容
            
            emoticonBtn.setImage(UIImage(contentsOfFile: emoticon.pngPath ?? ""), for: .normal)
            emoticonBtn.setTitle(emoticon.emojiCode, for: .normal)
            emoticonBtn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            
            if emoticon.isEmpty{
                emoticonBtn.setImage(UIImage(named : ""), for: .normal)
            }
            // 2. 设置删除按钮
            if emoticon.isRemove {
                emoticonBtn.setImage(UIImage(named : "compose_emotion_delete"), for: .normal)
            }
           
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
// MARK : 设置UI界面内容
extension EmoticonCollectionViewCell{
    fileprivate func setupUI(){
        // 1.添加子控件
        contentView.addSubview(emoticonBtn)
        // 2. 设置btn的frame
        emoticonBtn.frame = contentView.bounds
        // 3. 设置btn的属性
        emoticonBtn.isUserInteractionEnabled = false
    }
}
