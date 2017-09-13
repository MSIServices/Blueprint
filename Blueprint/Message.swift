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
    
    private var _messageId: Int!
    private var _text: String!
    private var _timestamp: Date!
    private var _sender: User!
    
    var messageId: Int {
        return _messageId
    }
    
    var text: String {
        return _text
    }
    
    var timestamp: Date {
        return _timestamp
    }
    
    var sender: User {
        return _sender
    }
    
    init(message: JSON) {
        
        self._messageId = message["messageId"].int
        self._text = message["text"].string
        
        if var dateString = message["timestamp"].string {
            self._timestamp = dateString.sqlToDate()
        }
        self._sender = User(userId: message["userId"].int!, email: nil, username: message["sender"].string)
    }
    
}
