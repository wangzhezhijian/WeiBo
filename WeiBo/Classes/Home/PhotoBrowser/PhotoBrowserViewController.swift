//
//  PhotoBrowserViewController.swift
//  WeiBo
//
//  Created by AISION on 17/6/1.
//  Copyright © 2017年 xiaokai.wang. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD
fileprivate let PhotoBrowserCell = "PhotoBrowserCell"
class PhotoBrowserViewController: UIViewController {
    
    // MARK:--定义属性
    var indexPath : NSIndexPath
    var picURLs : [URL]
    //MARK : --懒加载属性
    fileprivate lazy var collectionView : UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: PhotoBrowserViewLayout())
    fileprivate lazy var closeBtn : UIButton = UIButton(bgColor: UIColor.darkGray, fontSize: 14, title: "关 闭")
    
    fileprivate lazy var saveBtn : UIButton = UIButton(bgColor: UIColor.darkGray, fontSize: 14, title: "保 存")
    init(indexPath : NSIndexPath,picURLs : [URL]){
        self.indexPath = indexPath
        self.picURLs = picURLs
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view.frame.size.width += 20
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1. 设置UI界面
        setupUI()
        // 2. 滚动到对应的图片
        collectionView.scrollToItem(at: indexPath as IndexPath, at: .left, animated: false)
    }
}
extension PhotoBrowserViewController{
    fileprivate func setupUI(){
        // 1. 添加子控件
        view.addSubview(collectionView)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        // 2.设置frame
        collectionView.frame = view.bounds
        closeBtn.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(20)
            make.bottom.equalTo(-20)
            make.size.equalTo(CGSize(width: 90, height: 32))
        }
        saveBtn.snp.makeConstraints { (make) -> Void in
            make.right.equalTo(-20)
            make.bottom.equalTo(closeBtn.snp.bottom)
            make.size.equalTo(closeBtn.snp.size)
        }
        
        // 3. 设置collectionView的标识
        collectionView.register(PhotoBrowserCollectionViewCell.self, forCellWithReuseIdentifier: PhotoBrowserCell)
        collectionView.dataSource = self
        //4.监听两个按钮的点击
        closeBtn.addTarget(self, action: #selector(PhotoBrowserViewController.closeBtnClick), for: .touchUpInside)
        saveBtn.addTarget(self, action: #selector(PhotoBrowserViewController.saveBtnClick), for: .touchUpInside)
    }
}
extension PhotoBrowserViewController{
    //MARK:事件监听的函数
    @objc fileprivate func closeBtnClick(){
        dismiss(animated: true) { 
            
        }
    }
    @objc fileprivate func saveBtnClick(){
        //1. 获取当前显示的imageView
       let cell = collectionView.visibleCells.first as! PhotoBrowserCollectionViewCell
        guard let image =  cell.imageView.image else{
            return
        }
        //2. 将image对象保存到相册中
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_ : _: _:)), nil)
    }
    @objc fileprivate func image(_ image : UIImage,_ didFinishSavingWithError : Error?,_ contextInfo : AnyObject){
        var showInfo = ""
        if didFinishSavingWithError != nil{
            showInfo = "保存失败"
        }else{
            showInfo = "保存成功"
        }
        SVProgressHUD.showInfo(withStatus: showInfo)
    }
}
//MARK : --实现数据源方法
extension PhotoBrowserViewController : UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picURLs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1. 创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoBrowserCell, for: indexPath) as! PhotoBrowserCollectionViewCell
        // 2. 给cell设置数据
        cell.backgroundColor = indexPath.item % 2 == 0 ? UIColor.orange : UIColor.blue
        cell.picURL = picURLs[indexPath.item]
        cell.delegate=self
        return cell
    }
 
    
}
extension PhotoBrowserViewController : PhotoBrowserViewCellDelegate{
    func imageViewClick() {
        closeBtnClick()
    }
}
//MARK:--遵守animatorDismissDelegate
extension PhotoBrowserViewController : AnimatorDismissDelegate{
    func indexPathForDismissView() -> IndexPath {
        //1.获取当前正在显示的IndexPath
        let cell = collectionView.visibleCells.first!
        return collectionView.indexPath(for: cell)!
    }
    func imageViewForDismissView() -> UIImageView {
        //1. 创建UIImageView
        let imageView = UIImageView()
        //2. 设置imageView的frame
        let cell = collectionView.visibleCells.first as! PhotoBrowserCollectionViewCell
        imageView.frame = cell.imageView.frame
        imageView.image = cell.imageView.image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }
}
//MARK:--自定义布局
class PhotoBrowserViewLayout : UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        // 设置itemsize
        itemSize = collectionView!.frame.size
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        // 设置collectionView的属性
        self.scrollDirection = .horizontal
        collectionView?.isPagingEnabled = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
    }
}
