//
//  ComposeViewController.swift
//  WeiBo
//
//  Created by AISION on 17/5/17.
//  Copyright © 2017年 xiaokai.wang. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    @IBAction func picturePicker(_ sender: UIButton) {
        textView.resignFirstResponder()
        picPickerViewBottomCons.constant = (ScreenH-108)*0.65
        UIView.animate(withDuration: 1){
            self.view.layoutIfNeeded()
        }
    }
    @IBOutlet weak var picPickerViewBottomCons: NSLayoutConstraint!
    @IBOutlet weak var toolBarCons: NSLayoutConstraint!
    @IBOutlet weak var textView: ComposeTextView!
    // MARK:--懒加载属性
    lazy var titleView : ComposeTitleView = ComposeTitleView()
    // MARK: --系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置导航栏
        setupNav()
        
       // 创建通知
        setupNoti()
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
    
    
}
//MARK --photo代理方法
extension ComposeViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print(info)
        // 1. 获取选中的照片
        let image = info["UIImagePickerControllerOriginalImage"] as! UIImage
        // 展示照片
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
