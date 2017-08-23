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
    
    class func instanceFromNib() -> DoubleActionAlertV {
        return UINib(nibName: "DoubleActionAlertV", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! DoubleActionAlertV
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 3
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
    
    func configureView(image: String, header: String, subHeader: String, leftBtnText: String, rightBtnText: String, backgroundColor: UIColor, buttonNormalBackgroundColor: UIColor, buttonHighlightedBackgroundColor: UIColor) {
        
        iconImageView.image = UIImage(named: image)
        headerTextLbl.text = header
        subTextLbl.text = subHeader
        cancelBtn.setTitle(leftBtnText, for: .normal)
        confirmationBtn.setTitle(rightBtnText, for: .normal)
        self.backgroundColor = backgroundColor
        cancelBtn.backgroundColor = buttonNormalBackgroundColor
        confirmationBtn.backgroundColor = buttonNormalBackgroundColor
        cancelBtn.setBackgroundColor(color: buttonHighlightedBackgroundColor, forState: .highlighted)
        confirmationBtn.setBackgroundColor(color: buttonHighlightedBackgroundColor, forState: .highlighted)
    }

}
