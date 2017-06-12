//
//  PhotoBrowserCollectionViewCell.swift
//  WeiBo
//
//  Created by AISION on 17/6/1.
//  Copyright © 2017年 xiaokai.wang. All rights reserved.
//

import UIKit
import SDWebImage
protocol PhotoBrowserViewCellDelegate : NSObjectProtocol {
    func imageViewClick()
}

class PhotoBrowserCollectionViewCell: UICollectionViewCell {
    //MARK:定义属性
    var picURL : URL? {
        didSet{
            setupContent(picURL: picURL)
           
        }
    }
    var delegate : PhotoBrowserViewCellDelegate?
    //懒加载
    fileprivate lazy var scrollView : UIScrollView = UIScrollView()
    lazy var imageView : UIImageView = UIImageView()
    fileprivate lazy var progressView : ProgressView = ProgressView()
    override init(frame : CGRect){
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension PhotoBrowserCollectionViewCell{
    fileprivate func setupUI(){
        // 1.添加子控件
        contentView.addSubview(scrollView)
        contentView.addSubview(imageView)
        contentView.addSubview(progressView)
        // 2. 设置子控件frame
        scrollView.frame = contentView.bounds
        scrollView.frame.size.width -= 20
        progressView.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        progressView.center = CGPoint(x: ScreenW*0.5, y: ScreenH*0.5)
        // 设置控件的属性
        progressView.isHidden = true
        progressView.backgroundColor = UIColor.clear
        // 4. imageView的点击
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(PhotoBrowserCollectionViewCell.imageViewClick))
        imageView.addGestureRecognizer(tapGes)
        imageView.isUserInteractionEnabled = true
    }

}
extension PhotoBrowserCollectionViewCell{
    @objc fileprivate func imageViewClick(){
        delegate?.imageViewClick()
    }
}
extension PhotoBrowserCollectionViewCell{
    fileprivate func setupContent(picURL : URL?){
        guard let picURL = picURL else{
            return
        }
        // 2. 取出image对象
        let image = SDWebImageManager.shared().imageCache?.imageFromCache(forKey: picURL.absoluteString)
        //3. 计算iamgeView的frame
        let x = 0
        let width = ScreenW
        let height = width/(image?.size.width)! * (image?.size.height)!
        var y : CGFloat = 0
        if height > ScreenH{
            y=0
        }else{
            y = (ScreenH-height)*0.5
        }
        imageView.frame = CGRect(x: CGFloat(x), y: y, width: width, height: height)
        // 4. 设置imageView的图片
        progressView.isHidden = false
        imageView.sd_setImageWithPreviousCachedImage(with: getBigURL(smallURL: picURL), placeholderImage: image, options: [], progress: { (current, total, _) in
            self.progressView.progress = CGFloat(current)/CGFloat(total)
        }) { (_, _, _, _) -> Void in
            self.progressView.isHidden = true
        }
        
        imageView.image = image
        //5. 设置scrollView的contentSize
        scrollView.contentSize = CGSize(width: 0, height: height)
    }
    fileprivate func getBigURL(smallURL : URL) -> URL{
        let smallURLString = smallURL.absoluteString
      let bigURLString =  smallURLString.replacingOccurrences(of: "thumbnail", with: "bmiddle")
        return URL(string: bigURLString)!
    }
}
