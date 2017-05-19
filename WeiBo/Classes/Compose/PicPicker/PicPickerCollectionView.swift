//
//  PicPickerCollectionView.swift
//  WeiBo
//
//  Created by AISION on 17/5/18.
//  Copyright © 2017年 xiaokai.wang. All rights reserved.
//

import UIKit
fileprivate let picCell = "picCell"
fileprivate let edgeMargin : CGFloat = 15

class PicPickerCollectionView: UICollectionView {

    //MARK:定义属性
    var imagesArr : [UIImage] = [UIImage]() {
        didSet{
            reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // 设置线性布局
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let itemWH = (ScreenW - 4*edgeMargin)/3
        
        layout.itemSize = CGSize(width: itemWH, height: itemWH)
        layout.minimumInteritemSpacing = edgeMargin
        layout.minimumLineSpacing = edgeMargin
        
        register(UINib(nibName: "PictureCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: picCell)
       
        dataSource = self
        contentInset = UIEdgeInsetsMake(edgeMargin, edgeMargin, 0, edgeMargin)
    }

}
extension PicPickerCollectionView : UICollectionViewDataSource{
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArr.count+1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: picCell, for: indexPath) as! PictureCollectionViewCell
        
        // 给cell 设置数据
//        cell.backgroundColor = UIColor.red
        cell.image = indexPath.item <= imagesArr.count-1 ? imagesArr[indexPath.item] : nil
        return cell
    }
}
