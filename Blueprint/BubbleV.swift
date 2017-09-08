//
//  BubbleV.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 9/8/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import UIKit

class BubbleV: UIView {

    init(textField: CustomTF, user: UserCD, widthOfText: CGFloat, height: CGFloat, spacing: CGFloat, font: UIFont) {
        super.init(frame: CGRect(x: textField.textPaddingAdjustment, y: 0, width: widthOfText, height:  height))
        
        center.y = textField.bounds.size.height / 2
        backgroundColor = CHAIN_CREAM
        layer.cornerRadius = 6
        textField.addSubview(self)
        
        let textLbl = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        textLbl.center = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
        textLbl.text = user.username
        textLbl.font = font
        textLbl.textAlignment = .center
        self.addSubview(textLbl)
        
        textField.textPaddingAdjustment += widthOfText + (spacing * 2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
