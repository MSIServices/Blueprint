//
//  DoubleActionAlertV.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 7/29/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import UIKit

class DoubleActionAlertV: UIView {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var headerTextLbl: UILabel!
    @IBOutlet weak var subTextLbl: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var confirmationBtn: UIButton!
    @IBOutlet weak var iconImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var iconImageViewWidth: NSLayoutConstraint!
    @IBOutlet weak var btnHeight: NSLayoutConstraint!
    
    let developmentSize: CGFloat = 300.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 3
    }
    
    class func instanceFromNib() -> DoubleActionAlertV {
        return UINib(nibName: self.nameOfClass, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! DoubleActionAlertV
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        let hitView = super.hitTest(point, with: event)
        if hitView != nil {
            superview?.bringSubview(toFront: self)
        }
        return hitView
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        let rect = self.bounds
        var isInside = rect.contains(point)
        if !isInside {
            for view in subviews {
                isInside = view.frame.contains(point)
                if isInside {
                    break
                }
            }
        }
        return isInside
    }
    
    func configureView(image: String?, header: String, subHeader: String, leftBtnText: String, rightBtnText: String, backgroundColor: UIColor, buttonNormalBackgroundColor: UIColor, buttonHighlightedBackgroundColor: UIColor) {
        
        let scaleRatio = self.frame.size.height / self.developmentSize
        
        if let img = image {
            iconImageView.image = UIImage(named: img)
            iconImageViewWidth.constant = iconImageViewWidth.constant * scaleRatio
            iconImageViewHeight.constant = iconImageViewHeight.constant * scaleRatio
        } else {
            iconImageViewWidth.constant = 0
            iconImageViewHeight.constant = 0
        }
        
        headerTextLbl.font = UIFont(name: headerTextLbl.font.fontName, size: headerTextLbl.font.pointSize)
        headerTextLbl.text = header
        
        subTextLbl.font = UIFont(name: subTextLbl.font.fontName, size: subTextLbl.font.pointSize)
        subTextLbl.text = subHeader
        
        cancelBtn.setTitle(leftBtnText, for: .normal)
        cancelBtn.titleLabel?.font = UIFont(name: (cancelBtn.titleLabel?.font.fontName)!, size: (cancelBtn.titleLabel?.font.pointSize)! * scaleRatio)

        confirmationBtn.setTitle(rightBtnText, for: .normal)
        confirmationBtn.titleLabel?.font = UIFont(name: (confirmationBtn.titleLabel?.font.fontName)!, size: (confirmationBtn.titleLabel?.font.pointSize)! * scaleRatio)
        
        self.backgroundColor = backgroundColor
        cancelBtn.backgroundColor = buttonNormalBackgroundColor
        confirmationBtn.backgroundColor = buttonNormalBackgroundColor
        cancelBtn.setBackgroundColor(color: buttonHighlightedBackgroundColor, forState: .highlighted)
        confirmationBtn.setBackgroundColor(color: buttonHighlightedBackgroundColor, forState: .highlighted)
    }
    
    func addButtonBorder(color: UIColor, thickness: CGFloat) {
        
        cancelBtn.addViewBackedBorder(side: .north, thickness: thickness, color: color)
        confirmationBtn.addViewBackedBorder(side: .north, thickness: thickness, color: color)
        confirmationBtn.addViewBackedBorder(side: .west, thickness: thickness, color: color)
    }

}
