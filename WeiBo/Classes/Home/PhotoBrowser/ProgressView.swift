//
//  ProgressView.swift
//  WeiBo
//
//  Created by AISION on 17/6/6.
//  Copyright © 2017年 xiaokai.wang. All rights reserved.
//

import UIKit

class ProgressView: UIView {
    //MARK: 参数的改变
    var progress : CGFloat = 0{
        didSet{
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        //1获取参数
        let center = CGPoint(x: rect.width*0.5, y: rect.height*0.5)
        let radius = rect.width * 0.5 - 3
        let startAngle = CGFloat(-M_PI_2)
        let endAngle = CGFloat(2*M_PI)*progress + startAngle
        // 创建贝塞尔曲线
       let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        //绘制一条道中心点的线
        path.addLine(to: center)
        path.close()
        // 设置绘制的颜色
        
        UIColor(white: 1.0, alpha: 0.4).setFill()
        // 开始绘制
        path.fill()
    }

}
