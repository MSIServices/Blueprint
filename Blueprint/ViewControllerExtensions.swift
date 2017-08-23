//
//  ViewControllerExtensions.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/21/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
 
    func addBarButton(imageNormal: String, imageHighlighted: String?, action: Selector, side: Direction) {
    
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.setImage(UIImage(named: imageNormal), for: .normal)
        
        if let img = imageHighlighted {
            button.setImage(UIImage(named: img), for: .highlighted)
        }
        
        var barButton: UIBarButtonItem!
    
        if side == .west {
    
            barButton = UIBarButtonItem(customView: button)
            self.navigationItem.leftBarButtonItem = barButton
    
        } else if side == .east {
    
            barButton = UIBarButtonItem(customView: button)
            self.navigationItem.rightBarButtonItem = barButton
        }
    }

}
