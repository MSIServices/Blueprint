//
//  MessageDelegate.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/22/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import Foundation

 @objc protocol MessageDelegate {
    @objc optional func updateText(text: String?)
    @objc optional func updateUrl(text: String?)
    @objc optional func scrollToPoint(point: CGPoint)
}
