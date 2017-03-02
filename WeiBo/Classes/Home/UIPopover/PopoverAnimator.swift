//
//  PopoverAnimator.swift
//  WeiBo
//
//  Created by AISION on 17/3/1.
//  Copyright © 2017年 xiaokai.wang. All rights reserved.
//

import UIKit

class PopoverAnimator: NSObject {
    //MARK:--属性
    var isPresented : Bool = false
    var presentedFrame : CGRect = .zero
    
    var callBack : ((_ presented : Bool) -> ())?
    // MARK：--自定义构造函数
    // 注意：没有对默认的构造函数进行重写，则会覆盖
    
    init(callBack : @escaping (_ presented : Bool) -> ()) {
        self.callBack = callBack
    }
}
//MARK:--自定义转场，
extension PopoverAnimator : UIViewControllerTransitioningDelegate{
    //    目的改变弹出View的尺寸
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        let presentation = WxkPresentationController(presentedViewController: presented, presenting: presenting)
        presentation.presentedFrame = presentedFrame
        
        return presentation
    }
    // 自定义弹出的动画
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        callBack!(isPresented)
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        isPresented = false
        callBack!(isPresented)
        return self
    }
}
extension PopoverAnimator : UIViewControllerAnimatedTransitioning{
    // 动画执行的时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    // 获取‘转场上下文’: 可以通过转场上下文获取弹出的View和消失的View
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? animationForPresentedView(using: transitionContext) : animationForDismissView(using: transitionContext)
        
    }
    
    // 自定义弹出动画
    func animationForPresentedView(using transitionContext: UIViewControllerContextTransitioning) {
        //1.获取弹出的View
        // UITransitionContextFromViewKey, and UITransitionContextToViewKey
        let presentView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        
        // 2.将弹出的View 添加到containerView上
        transitionContext.containerView .addSubview(presentView)
        // 3.执行动画
        presentView.transform = CGAffineTransform.init(scaleX: 1.0, y: 0.0)
        presentView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            presentView.transform = .identity
        }) { (isFinished : Bool) in
            transitionContext.completeTransition(true)
        }
        
    }
    ///自定义消失动画
    func  animationForDismissView(using transitionContext: UIViewControllerContextTransitioning) {
        let dissmissView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        
        // 2.将弹出的View 添加到containerView上
        transitionContext.containerView .addSubview(dissmissView)
        // 3.执行动画
        //        presentView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            dissmissView.transform = CGAffineTransform.init(scaleX: 1.0, y: 0.0000001)
        }) { (isFinished : Bool) in
            dissmissView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
        
    }
    
}
