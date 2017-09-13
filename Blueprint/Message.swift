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
    
    init(id: Int, json: JSON) {
        self._messageId = id
        self._text = json["text"].string
        
        if var dateString = json["timestamp"].string {
            self._timestamp = dateString.sqlToDate()
        }
        self._sender = User(id: json["userId"].int!, json: json)
    }
    
}
