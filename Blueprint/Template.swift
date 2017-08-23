//
//  Template.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/9/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import Foundation

class Template {
    
    private var _id: String!
    private var _name: String?
    
    var id: String {
        return _id
    }
    
    var name: String? {
        return _name
    }
    
    init(id: String, dictionary: NSDictionary) {
        
        self._id = id
        
        if let name = dictionary.value(forKey: "name") as? String {
            _name = name
        }
    }
}
