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
    
    private var _conversationId: Int?
    private var _startDate: Date?
    private var _participants = [User]()
    private var _messages = [Message]()
    
    var conversationId: Int? {
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
            
            self._conversationId = json["conversationId"].int
            
            var lastMessageDate = json["lastMessageDate"].string!
            
            self._messages.append(Message(messageId: json["lastMessageId"].int!, text: json["lastMessage"].string!, timestamp: lastMessageDate.sqlToDate()))
            
            if let participants: String = json["participants"].string, let participantsIds: String = json["participantsIds"].string {
                
                let participantUsernames = participants.components(separatedBy: ",")
                let participantIds = participantsIds.components(separatedBy: ",").flatMap { Int($0) }
                
                for (i,username) in participantUsernames.enumerated() {
                    self._participants.append(User(userId: participantIds[i], email: nil, username: username))
                }
            }
        } else if type == ConversationType.detail {
            
            self._conversationId = json["conversation"]["conversationId"].int
            
            for user in json["participants"].arrayValue {
                _participants.append(User(json: user))
            }
            for msg in json["messages"].arrayValue {
                _messages.append(Message(message: msg))
            }
        }
    }
}
