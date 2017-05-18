//
//  PictureCollectionViewCell.swift
//  WeiBo
//
//  Created by AISION on 17/5/18.
//  Copyright © 2017年 xiaokai.wang. All rights reserved.
//

import UIKit

class PictureCollectionViewCell: UICollectionViewCell {

    @IBAction func addPhotoClick(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: PicPickerAddPhotoNote), object: nil)
      
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
