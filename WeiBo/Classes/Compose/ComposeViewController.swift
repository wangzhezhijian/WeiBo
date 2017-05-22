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
        
        self?.insertEmoticonIntoTextView(emoticon: emoticon)
    }
    fileprivate func insertEmoticonIntoTextView(emoticon : Emoticon){
        print(emoticon)
        // 1. 点击的有可能是空白表情
        if emoticon.isEmpty {
            return
        }
        //2.删除按钮
        if emoticon.isRemove {
            textView.deleteBackward()
            return
        }
        // 3.如果是emoji表情
        if emoticon.emojiCode != nil {
            // 3.1 获取光标所在的位置
            let textRange = textView.selectedTextRange!
            // 3.2 替换emoji表情
            textView.replace(textRange, withText: emoticon.emojiCode!)
            return
        }
        // 4. 普通表情: 图文混排
        // 4.1 根据图片路径创建属性字符串
        let attachment = NSTextAttachment()
        attachment.image = UIImage(contentsOfFile: emoticon.pngPath!)
        let font = textView.font!
        attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
        let attImageStr = NSAttributedString(attachment: attachment)
        
        // 4.2 创建可变的属性字符串
        let attMStr = NSMutableAttributedString(attributedString: textView.attributedText)
        // 4.3 将我们的图片属性字符串替换到可变属性字符串的某一个位置
        let range = textView.selectedRange
        attMStr.replaceCharacters(in: range, with: attImageStr)
        // 5 .显示属性字符串
        
        textView.attributedText = attMStr
        // 将文字的大小重置
        textView.font = font
        // 将光标设置为我们的原来位置+1
        textView.selectedRange = NSRange(location : range.location + 1,length : 0)
        
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
