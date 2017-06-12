//
//  HomeViewController.swift
//  WeiBo
//
//  Created by AISION on 17/2/7.
//  Copyright © 2017年 xiaokai.wang. All rights reserved.
//

import UIKit
import SDWebImage
import MJRefresh
class HomeViewController : BaseViewController {
    
    
    //MARK:--懒加载属性
    lazy var titleBtn : TitleButton = TitleButton()
    
    //注意：在闭包中如果使用当前对象的属性或者调用方法，也需要加self
    //两个地方需要使用self:1>如果一个函数出现歧义 2> 在闭包中使用当前对象的属性
    lazy var popoverAnimator : PopoverAnimator = PopoverAnimator { [weak self](presented)->() in
        self?.titleBtn.isSelected = presented
    }
    lazy var viewModels : [StatusViewModel] = [StatusViewModel]()
    
    // 下拉时的label
    lazy var tipLabel : UILabel = UILabel()
    fileprivate lazy var photoBrowserAnimator : PhotoBrowserAnimator = PhotoBrowserAnimator()
    //MARK:--系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        visitorView.addRotationAnim()
        // 1.没有登录时设置的内容
        if !isLogin{
            return
        }
        //2.设置导航栏的内容
        setupNavigationBar()
        
//        // 请求首页数据
//        loadStatus()
//        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        
        // 5,布局header
        setupHeaderView()
        // 6.布局footer
        setupFooterView()
        // 7.顶部tip
        setupTipLabel()
        // 8.监听通知
        setupNotifications()
    }


  

}

//MARK:--设置UI界面
extension HomeViewController{
    //1. 设置左侧的Item
    func setupNavigationBar(){
        //1.设置左侧的Item
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention")
        
        // 2.设置右侧的Item
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName:"navigationbar_pop")
        // 3. 设置titleView
       
        titleBtn.setTitle("哈哈哈", for: .normal)
        titleBtn.addTarget(self, action:#selector(titleBtnClick), for: .touchUpInside)
       
        navigationItem.titleView = titleBtn
        
    }
    // 下拉刷新
    func setupHeaderView(){
        // 创建headerView
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(HomeViewController.loadNewStatuses))
        header?.setTitle("下拉刷新", for: .idle)
        header?.setTitle("释放刷新", for: .pulling)
        header?.setTitle("正在刷新", for: .refreshing)
        
        // 设置tableViewHeader
        tableView.mj_header = header
        tableView.mj_header.beginRefreshing()
    }
    func setupFooterView() {
        // 创建footer
     tableView.mj_footer =  MJRefreshAutoFooter(refreshingTarget: self, refreshingAction: #selector(HomeViewController.loadMoreStatuses))
    }
    func setupTipLabel(){
        // 1. 将tipLabel添加到父控件
        navigationController?.navigationBar.insertSubview(tipLabel, at: 0)
        
        // 2.设置tipLabel的frame
        tipLabel.frame = CGRect(x: 0, y: 0, width: ScreenW, height: 32)
        // 3.设置tipLabel 的属性
        tipLabel.backgroundColor = UIColor.orange
        tipLabel.textColor = UIColor.white
        tipLabel.font = UIFont.systemFont(ofSize: 14)
        tipLabel.textAlignment = .center
        tipLabel.isHidden = true
    }
    func setupNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(showPhotoBrowser(_ :)), name: NSNotification.Name(rawValue: ShowPhotoBrowserNote), object: nil)
    }
}
//MARK:--NAV Title 点击事件
extension HomeViewController{
   
   @objc func titleBtnClick(){
    
    
        // 1.创建弹出的控制器
        let popoverVc = PopoverViewController()
        popoverVc.modalPresentationStyle = .custom
        // 2.设置转场的代理
        popoverVc.transitioningDelegate = popoverAnimator
        popoverAnimator.presentedFrame = CGRect(x: ScreenW/2-75, y: 60, width: 150, height: 250)
    
        //3.弹出控制器
        present(popoverVc, animated: true) { 
            
        }
    
    
    }
    @objc func showPhotoBrowser(_ note : Notification){
        //取出数据
        let indexPath = note.userInfo![ShowPhotoBrowserIndexKey]as! NSIndexPath
        let picURLs = note.userInfo![ShowPhotoBrowserUrlsKey]as! [URL]
        let object = note.object as! PicCollectionView
        // 创建控制器
        let photoBrowserVc = PhotoBrowserViewController(indexPath: indexPath , picURLs: picURLs )
        photoBrowserVc.modalPresentationStyle = .custom
        photoBrowserVc.transitioningDelegate = photoBrowserAnimator
        // 设置动画的delegate
        photoBrowserAnimator.presentedDelegate = object
        photoBrowserAnimator.dismissDelegate = photoBrowserVc
        photoBrowserAnimator.indexPath = indexPath as IndexPath
        // 以model的形势弹出
        present(photoBrowserVc, animated: true) {
            
        }
    }

}
// MARK : 封装请求数据
extension HomeViewController{
    // 加载最新的数据
    @objc func loadNewStatuses(){
        print("loadNewStatuses")
        loadStatus(isNewData: true)
    }
    // 加载更多的数据
    @objc func loadMoreStatuses(){
        print("loadNewStatuses")
        loadStatus(isNewData: false)
    }
    
    
    func loadStatus(isNewData : Bool)  {
        // 1.获取since_id 根据是不是最新数据
        var since_id = 0
        var max_id = 0
        if isNewData {
            since_id = viewModels.first?.status?.mid ?? 0
        }else{
            max_id = viewModels.last?.status?.mid ?? 0
            max_id = max_id == 0 ? 0 : (max_id - 1)
        }
        NetworkTools.shareInstance.loadStatuses(max_id:max_id,since_id: since_id) { (result, error) in
            if error != nil{
                print(error!)
                return
            }
           
            // 获取可选类型的数组
            guard  let resultArray = result else{
                return
            }
            
            // 遍历微博中对应的字典
            var tempViewModel = [StatusViewModel]()
            for statusDict in resultArray{
                print(statusDict)
                let status = Status(dict: statusDict)
                let viewModel = StatusViewModel(status: status)
                tempViewModel.append(viewModel)
            }
            //  4. 将数据放入到成员变量的数组中
            if isNewData{
                self.viewModels = tempViewModel + self.viewModels
            }else{
                self.viewModels += tempViewModel
            }
            // 5.缓存图片
            self.cacheImages(viewModels: tempViewModel)

        }
    }
    func cacheImages(viewModels : [StatusViewModel]) {
        // 0 创建group
       
        let group = DispatchGroup.init()
       
        
        for viewmodel in viewModels {
            for picURL in viewmodel.picURLs{
                 group.enter()
                SDWebImageDownloader.shared().downloadImage(with: picURL as URL, options: [], progress: nil, completed: { (image:UIImage?, data:Data?,error:Error?, finished:Bool) in
                    group.leave()
                
                    SDImageCache.shared().storeImageData(toDisk: data, forKey: picURL.absoluteString)
                    print("下载了一张图片")
                })
               
                
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            self.tableView.reloadData()
            print("刷新表格")
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            // 显示label
           
            self.showTipLabel(count: viewModels.count)
        }
    }
    /// 显示提示的label
    func showTipLabel(count : Int){
         tipLabel.isHidden = false
        tipLabel.text = count == 0 ? "没有新数据" : "\(count)条新微博"
        
        // 2.执行动画
        UIView.animate(withDuration: 1.0, animations: { 
            self.tipLabel.frame.origin.y = 44
        }) { (_) -> Void in
            UIView.animate(withDuration: 1.0, delay: 1.5, options: [], animations: { 
                self.tipLabel.frame.origin.y = 10
            }, completion: { (_) -> Void in
                self.tipLabel.isHidden = true
            })
        }
    }
}
// MARK:--tableViewDelegate
extension HomeViewController{
    // MARK: - Table view data source
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 1. 创建cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCellID") as! HomeViewCell
        // 给cell 设置数据
        let viewModel = viewModels[indexPath.row]
        
        cell.viewModel = viewModel
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModels.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 1. 获取模型对象
        let viewModel = viewModels[indexPath.row]
        return viewModel.cellHeight
    }

}
