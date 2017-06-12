//
//  ComposeViewController.swift
//  WeiBo
//
//  Created by AISION on 17/5/17.
//  Copyright © 2017年 xiaokai.wang. All rights reserved.
//

import UIKit
import SVProgressHUD
class ComposeViewController: UIViewController {

    @IBAction func picturePicker(_ sender: UIButton) {
        textView.resignFirstResponder()
        picPickerViewBottomCons.constant = (ScreenH-108)*0.65
        UIView.animate(withDuration: 1){
            self.view.layoutIfNeeded()
        }
    }
    // MARK:--表情键盘点击
    @IBAction func emotionBtnClick(_ sender: Any) {
        // 1. 退出键盘
        textView.resignFirstResponder()
        // 2. 切换键盘
       textView.inputView = textView.inputView != nil ? nil : emoticonVc.view
        // 3. 弹出键盘
        textView.becomeFirstResponder()
       
    }
    @IBOutlet weak var picPickerView: PicPickerCollectionView!
    @IBOutlet weak var picPickerViewBottomCons: NSLayoutConstraint!
    @IBOutlet weak var toolBarCons: NSLayoutConstraint!
    @IBOutlet weak var textView: ComposeTextView!
    // MARK:--懒加载属性
    lazy var titleView : ComposeTitleView = ComposeTitleView()
    fileprivate lazy var emoticonVc : EmoticonViewController = EmoticonViewController { [weak self] (emoticon) -> Void in
        self?.textView.insertEmoticon(emoticon: emoticon)
        self?.textViewDidChange(self!.textView)
    }
    fileprivate lazy var images : [UIImage] = [UIImage]()
    
   
    // MARK: --系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置导航栏
        setupNav()
        
       // 创建通知
        setupNoti()
        
        // 
      
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
extension ComposeViewController{
    func setupNav(){
        // 1.设置左右的item
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(ComposeViewController.closeItemClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: .plain, target: self, action: #selector(ComposeViewController.sendItemClick))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        // 2. 
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        navigationItem.titleView = titleView
        
    }
    //MARK: 通知封装
    fileprivate func setupNoti(){
        // 监听键盘弹出
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        // 监听添加照片的按钮的点击
        NotificationCenter.default.addObserver(self, selector: #selector(ComposeViewController.addPhotoClick), name: NSNotification.Name(rawValue: PicPickerAddPhotoNote), object: nil)
        // 删除照片的监听
        NotificationCenter.default.addObserver(self, selector: #selector(removePhotoClick(_:)), name: NSNotification.Name(rawValue: PicPickerRemovePhotoNote), object: nil)
    }
}
// MARK:--事件监听函数
extension ComposeViewController{
    @objc func closeItemClick(){
        dismiss(animated: true) { 
            
        }
    }
    @objc func sendItemClick(){
        print("send")
        
        print(textView.getEmoticonString())
        
        // 1. 获取发送微博的正文
        let statusText = textView.getEmoticonString()
        
        // 2.定义回调的闭包
        let finishedCallback = {(isSuccess : Bool) -> () in
            if !isSuccess{
                SVProgressHUD.show(withStatus: "发送微博失败")
                return
            }
            SVProgressHUD.show(withStatus: "发送微博成功")
            self.dismiss(animated: true, completion: {
                SVProgressHUD.dismiss()
            })

        }
        // 2.获取用户选中的图片
        
        
        if let image = images.first{
            NetworkTools.shareInstance.sendStatus(statusText: statusText, image: image, isSuccess: finishedCallback)
        }else{
        // 2. 调用接口发送微博
            NetworkTools.shareInstance.sendStatus(statusText: statusText, isSuccess : finishedCallback)
        }
    }
    @objc func keyboardWillChangeFrame(_ note : Notification){
        print(note.userInfo)
        // 获取动画执行的时间
        let duration = note.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        // 2.获取键盘最终Y值
        let endFrame = (note.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let y = endFrame.origin.y
        // 3.计算工具栏距离底部的间距
        let margin = UIScreen.main.bounds.height - y
        
        // 4.执行动画
        toolBarCons.constant = margin
        UIView.animate(withDuration: duration) { 
            self.view.layoutIfNeeded()
        }
        
    }
    // MARK:--添加和删除照片的事件
    @objc fileprivate func addPhotoClick(){
        print("监听")
        // 1. 判断照片源是否可用
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            return
        }
        // 2. 创建照片选择控制器
        let pic = UIImagePickerController()
        // 3. 设置照片源
        pic.sourceType = .photoLibrary
        
        // 4. 设置代理
        pic.delegate = self
        
        //5. 弹出控制器
        present(pic, animated: true) { 
            
        }

    }
    @objc fileprivate func removePhotoClick(_ note : NSNotification){
        print("删除照片")
        print(note.object)
        // 获取image对象
       guard let image = note.object as? UIImage else{
            return
       
        }
        // 2. 获取所在的下标值
        guard let index = images.index(of: image) else {
            return
        }
        // 3.将图片从数组中删除
        images.remove(at: index)
        // 4.重写赋值collectionView新的数组
        picPickerView.imagesArr = images
      
    }
    
    
}
//MARK --photo代理方法
extension ComposeViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print(info)
        // 1. 获取选中的照片
        let image = info["UIImagePickerControllerOriginalImage"] as! UIImage
        // 2.展示照片
        images.append(image)
        // 3.将数组赋值给collectionview 去展示数据
        picPickerView.imagesArr = images
        // 4. 退出选择照片控制器
        picker.dismiss(animated: true) { 
            self.textView.resignFirstResponder()
        }
        
    }
}
//MARK:--UITextView的代理方法
extension ComposeViewController : UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        print("----")
        self.textView.placeHolderLabel.isHidden = textView.hasText
        navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        textView.resignFirstResponder()
    }
}
