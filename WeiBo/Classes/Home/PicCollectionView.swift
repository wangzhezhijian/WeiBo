//
//  PicCollectionView.swift
//  WeiBo
//
//  Created by AISION on 17/3/22.
//  Copyright © 2017年 xiaokai.wang. All rights reserved.
//

import UIKit
import SDWebImage
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
        delegate = self
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
//MARK:--代理方法
extension PicCollectionView : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //1. 获取通知需要传递的参数
        let userInfo = [ShowPhotoBrowserIndexKey : indexPath,ShowPhotoBrowserUrlsKey : picURLs] as [String : Any]
        // 2. 发出通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ShowPhotoBrowserNote), object: self, userInfo: userInfo)
    }
}
extension PicCollectionView : AnimatorPresentedDelegate{
    
    func startRect(indexPath: IndexPath) -> CGRect {
        //1. 获取cell
        let cell = self.cellForItem(at: indexPath as IndexPath)!
        //2.获取cell的frame
       let startFrame = self.convert(cell.frame, to: UIApplication.shared.keyWindow)
        return startFrame
    }
    func endRect(indexPath: IndexPath) -> CGRect {
        // 1. 获取该位置的image对象
        let picURL = picURLs[indexPath.item]
        let image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: picURL.absoluteString)
        // 2。计算结束后的frame
        let w = ScreenW
        let h = w/(image?.size.width)!*(image?.size.height)!
        var y : CGFloat = 0
        if h > ScreenH{
            y = 0
        }else{
            y = (ScreenH-h)*0.5
        }
        return CGRect(x: 0, y: y, width: w, height: h)
    }
    func imageView(indexPath: IndexPath) -> UIImageView {
        // 1. 创建UIImageView的对想
        let imageView = UIImageView()
        // 1. 获取该位置的image对象
        let picURL = picURLs[indexPath.item]
        let image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: picURL.absoluteString)
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
        
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
