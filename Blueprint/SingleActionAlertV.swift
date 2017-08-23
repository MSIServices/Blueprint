//
//  SingleActionAlertV.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/12/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import UIKit
import SwiftyGif

class SingleActionAlertV: UIView {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var headerTextLbl: UILabel!
    @IBOutlet weak var subTextLbl: UILabel!
    @IBOutlet weak var confirmationBtn: UIButton!
    @IBOutlet weak var iconImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var iconImageViewWidth: NSLayoutConstraint!
    
    //Assuming height and width are equal.
    var developmentSize: CGFloat = 240.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 3
        self.confirmationBtn.layer.cornerRadius = 3
        self.isHidden = true
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
        
    class func nib() -> SingleActionAlertV {
        return UINib(nibName: "SingleActionAlertV", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SingleActionAlertV
    }
    
    func configureView(image: String, header: String, subHeader: String, btnText: String, backgroundColor: UIColor, buttonNormalBackgroundColor: UIColor, buttonHighlightedBackgroundColor: UIColor) {
        
        let scaleRatio = self.frame.size.height / self.developmentSize

        iconImageViewHeight.constant = iconImageViewHeight.constant * scaleRatio
        iconImageViewWidth.constant = iconImageViewWidth.constant * scaleRatio
        iconImageView.image = UIImage(named: image)
        
        let headerFontSize = headerTextLbl.font.pointSize
        
        headerTextLbl.font = UIFont(name: headerTextLbl.font.fontName, size: headerFontSize * scaleRatio)
        headerTextLbl.text = header
        
        let subHeaderFontSize = subTextLbl.font.pointSize
        
        subTextLbl.font = UIFont(name: subTextLbl.font.fontName, size: subHeaderFontSize * scaleRatio)
        subTextLbl.text = subHeader
        
        confirmationBtn.setTitle(btnText, for: .normal)
        confirmationBtn.titleLabel?.font = UIFont(name: (confirmationBtn.titleLabel?.font.fontName)!, size: (confirmationBtn.titleLabel?.font.pointSize)! * scaleRatio)
        
        self.backgroundColor = backgroundColor
        confirmationBtn.backgroundColor = buttonNormalBackgroundColor
        confirmationBtn.setBackgroundColor(color: buttonHighlightedBackgroundColor, forState: .highlighted)
    }
    
    
    //For use with GIF's
    func configureView(gif: String, header: String, subHeader: String, btnText: String, backgroundColor: UIColor, buttonNormalBackgroundColor: UIColor, buttonHighlightedBackgroundColor: UIColor) {
        
        let scaleRatio = self.frame.size.height / self.developmentSize
        
        iconImageViewHeight.constant = iconImageViewHeight.constant * scaleRatio
        iconImageViewWidth.constant = iconImageViewWidth.constant * scaleRatio
        
        let gifmanager = SwiftyGifManager(memoryLimit: 20)
        iconImageView.setGifImage(UIImage(gifName: gif), manager: gifmanager)
        
        let headerFontSize = headerTextLbl.font.pointSize
        
        headerTextLbl.font = UIFont(name: headerTextLbl.font.fontName, size: headerFontSize * scaleRatio)
        headerTextLbl.text = header
        
        let subHeaderFontSize = subTextLbl.font.pointSize
        
        subTextLbl.font = UIFont(name: subTextLbl.font.fontName, size: subHeaderFontSize * scaleRatio)
        subTextLbl.text = subHeader
        
        confirmationBtn.setTitle(btnText, for: .normal)
        confirmationBtn.titleLabel?.font = UIFont(name: (confirmationBtn.titleLabel?.font.fontName)!, size: (confirmationBtn.titleLabel?.font.pointSize)! * scaleRatio)
        
        self.backgroundColor = backgroundColor
        confirmationBtn.backgroundColor = buttonNormalBackgroundColor
        confirmationBtn.setBackgroundColor(color: buttonHighlightedBackgroundColor, forState: .highlighted)
    }
    
    func renderError(subHeader: String) {
        
        configureView(image: "error-white", header: "Error", subHeader: subHeader, btnText: "Ok", backgroundColor: ERROR, buttonNormalBackgroundColor: ERROR_BUTTON, buttonHighlightedBackgroundColor: ERROR_BUTTON_HIGHLIGHT)
    }
    
}
