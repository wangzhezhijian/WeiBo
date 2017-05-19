//
//  PictureCollectionViewCell.swift
//  WeiBo
//
//  Created by AISION on 17/5/18.
//  Copyright © 2017年 xiaokai.wang. All rights reserved.
//

import UIKit

class PictureCollectionViewCell: UICollectionViewCell {

    
   
    @IBOutlet weak var addPhotoBtn: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var removePhotoBtn: UIButton!
    @IBAction func addPhotoClick(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: PicPickerAddPhotoNote), object: nil)
      
    }
    @IBAction func removePhotoClick(_ sender: Any) {
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: PicPickerRemovePhotoNote), object: imageView.image)
    }
    // MARK : --定义属性
    var image : UIImage? {
        didSet{
            if image != nil{
                imageView.image = image
                addPhotoBtn.isUserInteractionEnabled = false
                removePhotoBtn.isHidden = false
            }else{
                addPhotoBtn.isUserInteractionEnabled = true

               imageView.image = nil
                removePhotoBtn.isHidden = true

            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
