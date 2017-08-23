//
//  Post.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/21/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Post {
    
    private var _postId: Int!
    private var _type: String!
    private var _text: String?
    private var _link: String?
    private var _image: String?
    private var _video: String?
    private var _audio: String?
    
    var postId: Int {
        return _postId
    }
    
    var type: String {
        return _type
    }
    
    var text: String? {
        return _text
    }
    
    var link: String? {
        return _link
    }
    
    var image: String? {
        return _image
    }
    
    var video: String? {
        return _video
    }
    
    var audio: String? {
        return _audio
    }
    
    init(id: Int, json: JSON) {
        self._postId = id
        self._type = json["type"].string
        self._text = json["text"].string
        self._link = json["link"].string
        self._image = json["image"].string
        self._video = json["video"].string
        self._audio = json["audio"].string
    }
    
}
