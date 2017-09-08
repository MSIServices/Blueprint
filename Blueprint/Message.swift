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
    private var _conversation: Conversation!
    
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
    
    var conversation: Conversation {
        return _conversation
    }
    
    init(id: Int, json: JSON) {
        self._messageId = id
        self._text = json["text"].string
//        self._timestamp = json["timestamp"].string
//        self._sender = json["sender"].string
//        self._conversation = json["conversation"].string
    }
    
}
