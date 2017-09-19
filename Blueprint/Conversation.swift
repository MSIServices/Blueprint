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
    
    private var _conversationId: NSNumber?
    private var _startDate: Date?
    private var _participants = [User]()
    private var _messages = [Message]()
    
    var conversationId: NSNumber? {
        return _conversationId
    }
    
    var startDate: Date? {
        return _startDate
    }
    
    var participants: [User] {
        return _participants
    }
    
    var messages: [Message] {
        return _messages
    }
    
    init(json: JSON, type: ConversationType) {
        
        if type == ConversationType.preview {
            
            self._conversationId = json["conversationId"].number
            
            var lastMessageDate = json["lastMessageDate"].string!
            
            self._messages.append(Message(messageId: json["lastMessageId"].number, text: json["lastMessage"].string!, timestamp: lastMessageDate.sqlToDate(), sender: User(userId: json["sender"].number, email: nil, username: nil)))
            
            if let participants: String = json["participants"].string, let participantsIds: String = json["participantsIds"].string {
                
                let participantUsernames = participants.components(separatedBy: ",")
                let participantIds = participantsIds.components(separatedBy: ",").flatMap { Int($0) }
                
                for (i,username) in participantUsernames.enumerated() {
                    self._participants.append(User(userId: participantIds[i] as NSNumber, email: nil, username: username))
                }
            }
        } else if type == ConversationType.detail {
            
            self._conversationId = json["conversation"]["conversationId"].number
            
            for user in json["participants"].arrayValue {
                _participants.append(User(json: user))
            }
            for msg in json["messages"].arrayValue {
                
                let user = User(userId: msg["userId"].number, email: nil, username: msg["username"].string)
                var timestamp = msg["timestamp"].string!

                _messages.append(Message(messageId: msg["messageId"].number, text: msg["text"].string, timestamp: timestamp.sqlToDate(), sender: user))
            }
        }
    }
}
