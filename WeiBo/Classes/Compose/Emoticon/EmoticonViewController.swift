//
//  EmoticonViewController.swift
//  WeiBo
//
//  Created by AISION on 17/5/19.
//  Copyright © 2017年 xiaokai.wang. All rights reserved.
//

import UIKit
fileprivate let EmoticonCell = "EmoticonCell"
class EmoticonViewController: UIViewController {

    //MARK : -定义属性
    var emoticonCallBack : (_ emoticon : Emoticon) -> ()
    //MARK:--懒加载属性
   
    fileprivate lazy var collectionView : UICollectionView = UICollectionView(frame: .zero , collectionViewLayout: EmoticonCollectionViewLayout())
    fileprivate lazy var toolBar : UIToolbar = UIToolbar()
    fileprivate lazy var manager : EmoticonManager = EmoticonManager()
    
    // MARK : -- 自定义构造函数
    init(emoticonCallBack : @escaping (_ emoticon : Emoticon) -> ()) {
        self.emoticonCallBack = emoticonCallBack
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    

}
extension EmoticonViewController {
    fileprivate func setupUI(){
        view.backgroundColor = UIColor.white
        //1. 添加子控件
        view.addSubview(collectionView)
        collectionView.backgroundColor = UIColor.white
        view.addSubview(toolBar)
        // 2. 设置子控件的frame
        collectionView.translatesAutoresizingMaskIntoConstraints  = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        let views = ["tBar" : toolBar,"cView" : collectionView] as [String : Any]
        var cons = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[tBar]-0-|", options: [], metrics: nil, views: views)
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[cView]-0-[tBar]-0-|", options: [.alignAllLeft,.alignAllRight], metrics: nil, views: views)
        view.addConstraints(cons)
        
        // 3. 准备collectionView
        prepareForCollectionView()
        // 4. 准备toolBar
        prepareForToolbar()
    }
    fileprivate func prepareForCollectionView(){
        // 1.注册cell 和设置数据源
        
        collectionView.register(EmoticonCollectionViewCell.self, forCellWithReuseIdentifier: EmoticonCell)
        collectionView.dataSource = self
        collectionView.delegate = self
        // 2.设置布局
        
        
    }
    fileprivate func prepareForToolbar(){
        // 1.定义toolBar中title
        let titles = ["最近","默认","emoji","浪小花"]
        
        //2.遍历标题，创建item
        var index = 0
        var tempItems = [UIBarButtonItem]()
        for title in titles{
            let item = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(itemClick(_:)))
            item.tag = index
            index += 1
            tempItems.append(item)
            tempItems.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        tempItems.removeLast()
        // 3. 设置toolBar的item数组
        toolBar.items = tempItems
        toolBar.tintColor = UIColor.orange
    }
    @objc fileprivate func itemClick(_ item : UIBarButtonItem){
        print(item.tag)
        let tag = item.tag
        // 2. 根据tag获取到当前组
        let indexPaths = NSIndexPath(item: 0, section: tag)
        //3.滚动到对应的位置
        collectionView.scrollToItem(at: indexPaths as IndexPath , at: .left, animated: true)
    }
}
extension EmoticonViewController : UICollectionViewDataSource,UICollectionViewDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return manager.packages.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let package = manager.packages[section]
        return package.emoticons.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1. 创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmoticonCell, for: indexPath) as! EmoticonCollectionViewCell
        // 2. 给cell 设置数据源
        cell.backgroundColor = UIColor.white
        
        // 3. 
        let package = manager.packages[indexPath.section]
        let emoticon = package.emoticons[indexPath.row]
        cell.emoticon = emoticon
        print(emoticon)
        return cell
    }
    // 代理方法
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 1. 取出点击的表情
        let package = manager.packages[indexPath.section]
        let emoticon = package.emoticons[indexPath.item]
        print(emoticon)
        // 2.将我们点击的表情插入到最近分组中
        insertRecentlyEmoticon(emoticon: emoticon)
        // 3. 将表情回调给外界的控制器
        emoticonCallBack(emoticon)
    }
    fileprivate func insertRecentlyEmoticon(emoticon : Emoticon){
        // 1. 如果是空白表情或者删除按钮，则不需要输入
        if emoticon.isRemove || emoticon.isEmpty{
            return
        }
        // 2. 删除一个biaoqing
        if manager.packages.first!.emoticons.contains(emoticon){
            // 原来有这个表情
            let index = (manager.packages.first?.emoticons.index(of: emoticon))!
            manager.packages.first?.emoticons.remove(at: index)
        }else{
            manager.packages.first?.emoticons.remove(at: 19)
        }
        // 2. 将emoticon插入到最近分组中
        manager.packages.first?.emoticons.insert(emoticon, at: 0)
    }
}

class EmoticonCollectionViewLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        // 1. 计算itemWH
        let itemWH = UIScreen.main.bounds.width / 7
        
        // 2.设置layout的属性
        itemSize = CGSize(width: itemWH, height: itemWH)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        // 3. 设置collectionView的属性
        collectionView?.isPagingEnabled = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        let insetMargin = ((collectionView?.bounds.height)! - 3*itemWH)/2
        collectionView?.contentInset = UIEdgeInsets(top: insetMargin, left: 0, bottom: insetMargin, right: 0)
        
    }
}
