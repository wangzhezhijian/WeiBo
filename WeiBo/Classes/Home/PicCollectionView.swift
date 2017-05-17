//
//  PicCollectionView.swift
//  WeiBo
//
//  Created by AISION on 17/3/22.
//  Copyright © 2017年 xiaokai.wang. All rights reserved.
//

import UIKit

class PicCollectionView: UICollectionView {

    //MARK:--定义属性
    var picURLs : [NSURL] = [NSURL](){
        didSet{
            self.reloadData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        dataSource = self
    }

}
//MARK--collectionView的数据源方法
extension PicCollectionView : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picURLs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 获取cell 
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PicCell", for: indexPath) as! PicCollectionViewCell
        
        // 2.给cell设置数据
//        cell.backgroundColor = UIColor.red
        cell.picURL = picURLs[indexPath.item] as URL
        
        return cell
    }
}
class PicCollectionViewCell: UICollectionViewCell {
    //MARK--控件的属性
    @IBOutlet weak var iconView: UIImageView!
     // MARK:-- 定义模型属性
    var picURL : URL? {
        didSet{
            guard let picURL = picURL else {
                return
            }
            iconView.sd_setImage(with: picURL, placeholderImage: UIImage(named: "empty_picture"))
        }
    }
    
}
