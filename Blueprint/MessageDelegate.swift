//
//  MessageDelegate.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/22/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import Foundation

 protocol MessageDelegate {
     optional func updateText(text: String?)
     optional func updateUrl(text: String?)
     optional func scrollToPoint(point: CGPoint)
}
