//
//  HomeViewCell.swift
//  WeiBo
//
//  Created by AISION on 17/3/14.
//  Copyright © 2017年 xiaokai.wang. All rights reserved.
//

import UIKit
import SDWebImage
private let edgeMargin : CGFloat = 15
private let itemMargin : CGFloat = 10
class HomeViewCell: UITableViewCell {
    //MARK:--控件的属性
    
    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var verifiedView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var vipView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    //MARK:--约束的属性
    @IBOutlet weak var contentLabelWcons: NSLayoutConstraint!
    
    @IBOutlet weak var picViewHCons: NSLayoutConstraint!
    @IBOutlet weak var picViewWCons: NSLayoutConstraint!
    
    @IBOutlet weak var retweetedContentLabel: UILabel!
    
    @IBOutlet weak var bottomToolView: UIView!
    @IBOutlet weak var reteweetedContentLabelTopCons: NSLayoutConstraint!
    @IBOutlet weak var picViewBottomCons: NSLayoutConstraint!
    @IBOutlet weak var retweetedBgView: UIView!
    @IBOutlet weak var picView: PicCollectionView!
    // MARK:--自定义属性
    var viewModel : StatusViewModel?{
        didSet{
            // 1.nil 值校验
            guard let viewModel = viewModel else {
                return
            }
            // 2.设置头像
           
            iconView.sd_setImage(with: viewModel.profileURL as URL?, placeholderImage: UIImage(named: ""))
            // 3. 设置认证的图标
            verifiedView.image = viewModel.verifiedImage
            //4. 处理昵称
            screenNameLabel.text = viewModel.status?.user?.screen_name
            //5.会员图标
            vipView.image = viewModel.vipImage
            // 6.设置时间的label
            timeLabel.text = viewModel.createText
            // 7. 设置来源
            
            if let sourceText = viewModel.sourceText {
                 sourceLabel.text = "来自" + sourceText
            }else{
                sourceLabel.text = nil
            }
           
            // 8.设置正文
            let statusText = viewModel.status?.text
            
            contentLabel.attributedText = FIndEmoticon.shareIntance.findAttString(statusText: statusText ,font: contentLabel.font)
            // 9.设置昵称的文字颜色
            screenNameLabel.textColor = viewModel.vipImage == nil ? UIColor.black : UIColor.orange
            // 10.计算picView的宽度和高度的约束
            let picViewSize = calculatePicViewSize(count: viewModel.picURLs.count)
            picViewWCons.constant = picViewSize.width
            picViewHCons.constant = picViewSize.height
            // 10.将picURL数据传递给picView
            picView.picURLs = viewModel.picURLs
            // 11.设置转发微博的正文
            if viewModel.status?.retweeted_status != nil {
                if let screenName = viewModel.status?.retweeted_status?.user?.screen_name,let retweetedText = viewModel.status?.retweeted_status?.text{
                    
                    let retweetText =  "@" + "\(screenName): " + retweetedText
                   retweetedContentLabel.attributedText = FIndEmoticon.shareIntance.findAttString(statusText: retweetText, font: retweetedContentLabel.font)
                    
                    // 设置转发正文距离顶部的约束
                    reteweetedContentLabelTopCons.constant = 15
                }
                // 2.设置背景的显示
                retweetedBgView.isHidden = false
               
               
            }else{
                retweetedBgView.isHidden = true
                reteweetedContentLabelTopCons.constant = 0

                retweetedContentLabel.text = nil
            }
            // 12 计算cell的高度
            if viewModel.cellHeight == 0 {
                // 12.1强制布局
                layoutIfNeeded()
                // 12.2 获取底部工具栏的最大Y值
                viewModel.cellHeight =  (bottomToolView?.frame)!.maxY
            }
           
        }
    }
    
    // MARK:--系统回调函数
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // 设置微博正文宽度的约束
        contentLabelWcons.constant = UIScreen.main.bounds.width - 2*edgeMargin
        
    }

   
}
//MARK:--计算picView方法
extension HomeViewCell{
    func calculatePicViewSize(count : Int) -> CGSize {
        // 1.没有配图
        if count==0{
            picViewBottomCons.constant = 0
           return CGSize(width: 0, height: 0)
        }
        // 取出picView对应的layout
        let layout = picView.collectionViewLayout as! UICollectionViewFlowLayout
       

        if count==1{
            let urlString = viewModel?.picURLs.last?.absoluteString
            print(urlString)
            print(SDImageCache.shared().getDiskCount())
            SDImageCache.shared().queryCacheOperation(forKey: urlString, done: { (image:UIImage?, data:Data?, cacheType:SDImageCacheType) in
                print("缓存中查找到了")
            })
            guard let image1 = SDImageCache.shared().imageFromDiskCache(forKey: urlString) else {
                return .zero
            }
            print(image1)
            var imageH : CGFloat = 0
            var imageW : CGFloat = 0
            if (image1.size.height) > ScreenH {
                imageH = ScreenH/3
            }else if (image1.size.height) < ScreenH/2{
                imageH = (image1.size.height)
            }else{
                imageH = ScreenH/2
            }
            if (image1.size.width) > ScreenW {
                imageW = ScreenW/2
            }else{
                imageW = (image1.size.height)
            }
            
            layout.itemSize = CGSize(width: imageW, height: imageH)
            return CGSize(width: imageW, height: imageH)
        }
        // 2.计算出来imageView
        let imageViewWH = (UIScreen.main.bounds.width - 2*itemMargin - 2*edgeMargin)/3
        layout.itemSize = CGSize(width: imageViewWH, height: imageViewWH)
        //3.4张配图
        if count == 4 {
            let picViewH = imageViewWH*2 + itemMargin
            return CGSize(width: picViewH, height: picViewH)
        }
        //4.其他配图
        //4.1 计算行数
        let rows = CGFloat((count - 1)/3 + 1)
        //4.2 计算picView的高度
        let picViewH = rows * imageViewWH + (rows-1)*itemMargin
        //4.3 计算picView的宽度
        let picViewW = UIScreen.main.bounds.width - 2*edgeMargin
        return CGSize(width: picViewW, height: picViewH)
    }
}
