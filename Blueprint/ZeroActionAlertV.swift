//
//  ZeroActionAlertV.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/22/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import UIKit
import SwiftyGif

class ZeroActionAlertV: UIView {

    @IBOutlet weak var iconImageViewWidth: NSLayoutConstraint!
    @IBOutlet weak var iconImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var subHeaderLbl: UILabel!
    
    //Assuming height and width are equal.
    var developmentSize: CGFloat = 240.0

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 3
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
    
    class func nib() -> ZeroActionAlertV {
        return UINib(nibName: "ZeroActionAlertV", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ZeroActionAlertV
    }
    
    func configureView(image: String, header: String, subHeader: String, btnText: String, backgroundColor: UIColor, buttonNormalBackgroundColor: UIColor, buttonHighlightedBackgroundColor: UIColor) {
        
        let scaleRatio = self.frame.size.height / self.developmentSize
        
        iconImageViewHeight.constant = iconImageViewHeight.constant * scaleRatio
        iconImageViewWidth.constant = iconImageViewWidth.constant * scaleRatio
        iconImageView.image = UIImage(named: image)
        
        let headerFontSize = headerLbl.font.pointSize
        
        headerLbl.font = UIFont(name: headerLbl.font.fontName, size: headerFontSize * scaleRatio)
        headerLbl.text = header
        
        let subHeaderFontSize = subHeaderLbl.font.pointSize
        
        subHeaderLbl.font = UIFont(name: subHeaderLbl.font.fontName, size: subHeaderFontSize * scaleRatio)
        subHeaderLbl.text = subHeader
        
        self.backgroundColor = backgroundColor
    }
    
    //For use with GIF's
    func configureView(gif: String, header: String, subHeader: String, backgroundColor: UIColor) {
        
        let scaleRatio = self.frame.size.height / self.developmentSize
        
        iconImageViewHeight.constant = iconImageViewHeight.constant * scaleRatio
        iconImageViewWidth.constant = iconImageViewWidth.constant * scaleRatio

        let gifmanager = SwiftyGifManager(memoryLimit: 20)
        iconImageView.setGifImage(UIImage(gifName: gif), manager: gifmanager)
        iconImageView.animationDuration = 1.0

        let headerFontSize = headerLbl.font.pointSize
        
        headerLbl.font = UIFont(name: headerLbl.font.fontName, size: headerFontSize * scaleRatio)
        headerLbl.text = header
        
        let subHeaderFontSize = subHeaderLbl.font.pointSize
        
        subHeaderLbl.font = UIFont(name: subHeaderLbl.font.fontName, size: subHeaderFontSize * scaleRatio)
        subHeaderLbl.text = subHeader
        
        self.backgroundColor = backgroundColor
    }

}
