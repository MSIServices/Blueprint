//
//  UIButtonExtensions.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/11/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    func setBackgroundColor(color: UIColor, forState: UIControlState) {
        
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(colorImage, for: forState)
    }
    
    func addButtonDivider(width: CGFloat, color: UIColor = UIColor.lightText) {
        
        let divider = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.bounds.size.height))
        divider.backgroundColor = color
        self.addSubview(divider)
    }
        
}
