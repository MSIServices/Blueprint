//
//  Group.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/21/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Group {
    
    private var _groupId: Int!
    private var _name: String!
    private var _descrip: String!
    private var _imageUrl: String?
    
    var groupId: Int {
        return _groupId
    }
    
    var name: String {
        return _name
    }
    
    var descrip: String {
        return _descrip
    }
    
    var imageUrl: String? {
        return _imageUrl
    }
    
    init(id: Int, json: JSON) {
        self._groupId = id
        self._name = json["name"].string
        self._descrip = json["descrip"].string
        self._imageUrl = json["imageUrl"].string
    }
    
}
