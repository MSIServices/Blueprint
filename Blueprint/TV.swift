//
//  TV.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/23/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import UIKit

class TV: UITextView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        autocorrectionType = .no
    }

    override func deleteBackward() {
        super.deleteBackward()
        
        NotificationCenter.default.post(name: Notifications.customNotification.BackspaceDetected, object: nil)
    }
    
}
