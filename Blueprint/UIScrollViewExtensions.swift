//
//  ScrollViewExtensions.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/11/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import Foundation
import UIKit

extension UIScrollView {
    
    // Scroll to a specific view so that it's top is at the top our scrollview
    func scrollToView(view:UIView, animated: Bool) {
        
        if let origin = view.superview {
            
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            self.scrollRectToVisible(CGRect(x: 0, y: childStartPoint.y, width: 1, height: self.frame.size.height), animated: animated)
        }
    }
    
    func scrollDownBy(amount: CGFloat) {
        setContentOffset(CGPoint(x: 0, y: contentOffset.y + amount), animated: true)
    }
    
    func scrollUpBy(amount: CGFloat) {
        setContentOffset(CGPoint(x: 0, y: contentOffset.y - amount), animated: true)
    }
    
    func scrollToTop(animated: Bool) {
        
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }
    
    func scrollToBottom(animated: Bool) {
        
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if bottomOffset.y > 0 {
            setContentOffset(bottomOffset, animated: animated)
        }
    }
    
}
