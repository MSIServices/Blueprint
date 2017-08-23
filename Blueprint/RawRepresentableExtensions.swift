//
//  RawRepresentableExtensions.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/11/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import Foundation

extension RawRepresentable where RawValue == String, Self: NotificationName {
    var BackspaceDetected: Notification.Name {
        get {
            return Notification.Name(self.rawValue)
        }
    }
}
