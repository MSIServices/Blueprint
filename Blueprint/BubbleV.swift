//
//  BubbleV.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 9/8/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import UIKit

class BubbleV: UIView {

    init(textView: TV, user: UserCD, widthOfText: CGFloat, height: CGFloat, spacing: CGFloat, font: UIFont, centerOffset: CGFloat) {
        super.init(frame: CGRect(x: textView.xAdjustment, y: textView.yAdjustment, width: widthOfText, height:  height))
    
        center.y = centerOffset
        backgroundColor = CHAIN_CREAM
        layer.cornerRadius = 6
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1.0
        textView.addSubview(self)
        
        let textLbl = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        textLbl.center = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
        textLbl.text = user.username
        textLbl.font = font
        textLbl.textAlignment = .center
        self.addSubview(textLbl)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
