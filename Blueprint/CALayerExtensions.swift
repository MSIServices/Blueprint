//
//  CALayer.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/11/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import Foundation
import UIKit

extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: self.frame.size.height - thickness, width: UIScreen.main.bounds.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: self.frame.size.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x: self.frame.size.width - thickness, y: 0, width: thickness, height: self.frame.size.height)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor
        
        self.addSublayer(border)
    }
    
}
