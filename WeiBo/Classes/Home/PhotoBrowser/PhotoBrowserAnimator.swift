//
//  PhotoBrowserAnimator.swift
//  WeiBo
//
//  Created by AISION on 17/6/8.
//  Copyright © 2017年 xiaokai.wang. All rights reserved.
//

import UIKit
// 面向协议开发 ---> 面向接口开发
protocol AnimatorPresentedDelegate : NSObjectProtocol{
    func startRect(indexPath : IndexPath) -> CGRect
    func endRect(indexPath : IndexPath) -> CGRect
    func imageView(indexPath : IndexPath) -> UIImageView
}
protocol AnimatorDismissDelegate : NSObjectProtocol {
    func indexPathForDismissView() -> IndexPath
    func imageViewForDismissView() -> UIImageView
}

class PhotoBrowserAnimator: NSObject {
    var isPresented : Bool = false
    var presentedDelegate : AnimatorPresentedDelegate?
    var indexPath : IndexPath?
    var dismissDelegate : AnimatorDismissDelegate?
}

extension PhotoBrowserAnimator : UIViewControllerTransitioningDelegate{
    //自定义弹出动画
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
}
extension PhotoBrowserAnimator : UIViewControllerAnimatedTransitioning{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? animationForPresentedView(using: transitionContext) :animationForDismissView(using: transitionContext)
        
    }
    // 弹出
    func animationForPresentedView(using transitionContext: UIViewControllerContextTransitioning){
        // 0.nil值校验
        guard let presentedDelegate = presentedDelegate,let indexPath = indexPath else{
            return
        }
        // 1. 取出弹出的view
        let presentedView = transitionContext.view(forKey: .to)
        //2.将presentedView添加到containerView中
        transitionContext.containerView.addSubview(presentedView!)
        
        // 3. 获取执行动画的iamgeView
        let startRect = presentedDelegate.startRect(indexPath: indexPath)
        let imageView = presentedDelegate.imageView(indexPath: indexPath)
        transitionContext.containerView.addSubview(imageView)
        imageView.frame = startRect
        
        //3. 执行动画
        presentedView?.alpha = 0.0
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { () -> Void in
            imageView.frame = presentedDelegate.endRect(indexPath: indexPath)
           
        }) { (_) -> Void in
             imageView.removeFromSuperview()
            presentedView?.alpha = 1.0
            transitionContext.completeTransition(true)
        }
    }
    //消失动画
    func animationForDismissView(using transitionContext: UIViewControllerContextTransitioning) {
        // nil 值校验
        guard let presentedDelegate = presentedDelegate,let dismissDelegate = dismissDelegate else{
            return
        }
        // 1. 取出弹出的view
        let dismissView = transitionContext.view(forKey: .from)
        dismissView?.removeFromSuperview()

        // 2. 获取执行动画的ImageView
        let imageView = dismissDelegate.imageViewForDismissView()
        let indexPath = dismissDelegate.indexPathForDismissView()
        transitionContext.containerView.addSubview(imageView)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { () -> Void in
            imageView.frame = presentedDelegate.startRect(indexPath: indexPath)
        }) { (_) -> Void in
            dismissView?.removeFromSuperview()
            transitionContext.completeTransition(true)
        }

    }
}
