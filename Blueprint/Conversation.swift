//
//  Conversation.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 9/7/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Conversation {
    
    private var _conversationId: Int!
    private var _startDate: Date!
    private var _lastMessageDate: Date!
    private var _participants = [User]()
    private var _messages = [Message]()
    
    var conversationId: Int {
        return _conversationId
    }
    
    var startDate: Date {
        return _startDate
    }
    
    var lastMessageDate: Date {
        return _lastMessageDate
    }
    
    var participants: [User] {
        return _participants
    }
    
    var messages: [Message] {
        return _messages
    }
    
    init(id: Int, json: JSON) {
        self._conversationId = id
//        self._startDate = json["startDate"].string
//        self._lastMessageDate = json["lastMessageDate"].string
        self._participants = json["participants"] as! [User]
        self._messages = json["messages"] as! [Message]
    }
    
}
