//
//  TV.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/23/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import UIKit

class TV: UITextView {
    
    var xAdjustment: CGFloat = 5
    var yAdjustment: CGFloat = 15
    private var _recipientV = false
    
    var recipientV: Bool {
        get {
            return _recipientV
        }
        set {
            _recipientV = newValue
            
            if recipientV {
                textContainerInset = UIEdgeInsets(top: yAdjustment, left: xAdjustment, bottom: 0, right: 0)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        autocorrectionType = .no
    }
    
    override func deleteBackward() {
        super.deleteBackward()
        
        NotificationCenter.default.post(name: Notifications.customNotification.BackspaceDetected, object: nil)
    }
    
    func getCurrentInsets() -> UIEdgeInsets {
        
        let insets = UIEdgeInsets(top: self.yAdjustment, left: self.xAdjustment, bottom: 0, right: 0)
        return insets
    }
    
}
