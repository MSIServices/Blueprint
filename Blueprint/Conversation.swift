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
    private var _participants = [User]()
    private var _messages = [Message]()
    
    var conversationId: Int {
        return _conversationId
    }
    
    var startDate: Date {
        return _startDate
    }
    
    var participants: [User] {
        return _participants
    }
    
    var messages: [Message] {
        return _messages
    }
    
    init(json: JSON) {
        
        self._conversationId = json["conversation"]["conversationId"].int
        
        if var dateString = json["conversation"]["startDate"].string {
            self._startDate = dateString.sqlToDate()
        }
        
        for user in json["participants"].arrayValue {
            _participants.append(User(json: user))
        }
        for msg in json["messages"].arrayValue {
            _messages.append(Message(message: msg))
        }
    }
    
//    //Not sure what this is for yet.
//    init(json: JSON) {
//        
//        self._conversationId = json["conversation"]["conversationId"].int
//        
//        if var dateString = json["conversation"]["startDate"].string {
//            self._startDate = dateString.sqlToDate()
//        }
//        _participants.append(User(id: json["message"]["userId"].int!, json: json))
//        
//        for recipient in json["recipients"].array! {
//            _participants.append(User(id: recipient["userId"].int!, json: recipient))
//        }
//        _messages.append(Message(id: json["message"]["messageId"].int!, json: json["message"]))
//    }
//    
}
