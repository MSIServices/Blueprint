//
//  CustomB.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/11/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import UIKit

class CustomB: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setBorderWithColor(color: CHAIN_CREAM, borderWidth: 2)
//        setCornerRadius(num: 2.0)
        setTitleColor(CHAIN_CREAM, for: .normal)
    }
    
    func setBorderWithColor(color: UIColor, borderWidth: Int) {
        
        layer.borderColor = color.cgColor
        layer.borderWidth = CGFloat(borderWidth)
    }
    
    func setCornerRadius(num: CGFloat) {
        layer.cornerRadius = num
    }
}
