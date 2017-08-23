//
//  ProgressCircleV.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/11/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import UIKit

class ProgressCircleV: UIView {

    let circleShape = CAShapeLayer()
    let developmentSize: CGFloat = 300
    
    var label: UILabel!
    var scaleRatio: CGFloat!
    var lineWidth: CGFloat!
    var circlePath: UIBezierPath!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(size: CGFloat, color: UIColor) {
        super.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
        
        scaleRatio = size / developmentSize
        lineWidth = 20 * scaleRatio
        
        circlePath = UIBezierPath(arcCenter: CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2),
                                  radius: self.frame.size.width / 2,
                                  startAngle: CGFloat(-0.5 * Double.pi),
                                  endAngle: CGFloat(1.5 * Double.pi),
                                  clockwise: true)
        
        
        self.center = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = self.frame.size.width / 2
        
        circleShape.path = circlePath.cgPath
        circleShape.lineCap = kCALineCapRound
        circleShape.strokeColor = color.cgColor
        circleShape.fillColor = UIColor.clear.cgColor
        circleShape.lineWidth = lineWidth
        circleShape.strokeStart = 0.0
        circleShape.strokeEnd = 0.0
        
        self.layer.addSublayer(circleShape)
        
        label = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width - lineWidth, height: 80 * scaleRatio))
        label.textAlignment = .center
        label.font = UIFont(name: "Ubuntu-Bold", size: 80 * scaleRatio)
        label.center = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
        
        self.addSubview(label)
    }
    
    func setText(text: String) {
        label.text = text
    }
    
    func animateStroke(toValue: CGFloat, duration: CFTimeInterval = 1) {
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = 0.0
        animation.toValue = toValue
        animation.isRemovedOnCompletion = false
        
        circleShape.add(animation, forKey: nil)
    }

}
