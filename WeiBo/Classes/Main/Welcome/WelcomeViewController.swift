//
//  WelcomeViewController.swift
//  WeiBo
//
//  Created by AISION on 17/3/8.
//  Copyright © 2017年 xiaokai.wang. All rights reserved.
//

import UIKit
import SDWebImage
class WelcomeViewController: UIViewController {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var iconViewBottomCons: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        //0.设置头像
        let profileURLString = UserAccountViewModel.shareIntance.account?.avatar_large
        
        // 如果前面的可选类型为nil，那么直接使用？？后面的值
        let url = URL(string: profileURLString ?? "")
        iconView.sd_setImage(with: url, placeholderImage: UIImage(named: "avatar_default_big"))
        // 1.改变约束的值
        iconViewBottomCons.constant = UIScreen.main.bounds.height-200
        // 2.执行动画 Damping : 阻力系数，阻力系数越大，弹性效果越不明显0——1
        //initialSpringVelocity : 初始化速度
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: [], animations: {
            self.view.layoutIfNeeded()
        }) { (_) -> Void in
            UIApplication.shared.keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
