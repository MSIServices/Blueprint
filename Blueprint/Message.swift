//
//  Message.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 9/7/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Message {
    
    private var _messageId: NSNumber?
    private var _text: String?
    private var _timestamp: Date?
    private var _sender: User?
    
    var messageId: NSNumber? {
        return _messageId
    }
    
    var text: String? {
        return _text
    }
    
    var timestamp: Date? {
        return _timestamp
    }
    
    var sender: User? {
        return _sender
    }
    
    init(messageId: Int?, text: String?, timestamp: Date?) {
        self._messageId = messageId as NSNumber?
        self._text = text
        self._timestamp = timestamp
    }
    
    init(message: JSON) {
        
        self._messageId = message["messageId"].int as NSNumber?
        self._text = message["text"].string
        
        if var dateString = message["timestamp"].string {
            self._timestamp = dateString.sqlToDate()
        }
        self._sender = User(userId: message["userId"].int!, email: nil, username: message["sender"].string)
    }
    
}
