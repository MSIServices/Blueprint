//
//  User.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/15/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import Foundation
import SwiftyJSON

struct User {
    
    private var _userId: Int!
    private var _email: String?
    private var _username: String?
    private var _avatar: String?
    
    var userId: Int {
        return _userId
    }
    
    var email: String? {
        return _email
    }
    
    var username: String? {
        return _username
    }
    
    var avatar: String? {
        return _avatar
    }
    
    static var currentId: NSNumber {
        return UserDefaults.standard.value(forKey: USER_ID) as! NSNumber
    }
    
    static var email: String {
        return UserDefaults.standard.value(forKey: EMAIL) as! String
    }

    static var username: String {
        return UserDefaults.standard.value(forKey: USERNAME) as! String
    }
    
    init(userId: Int, email: String, username: String) {
        self._userId = userId
        self._email = email
        self._username = username
    }
    
    //Probably should keep these for single purpose and seperate inits for different functions
    init(id: Int, json: JSON) {
        self._userId = id
        
        if let email = json["email"].string {
            self._email = email
        }
        print(json["username"].string)
        if let username = json["username"].string {
            self._username = username
        }
        
        if let avatar = json["avatar"].string {
            self._avatar = avatar
        }
    }
    
    func current() -> User {
        return User(userId: UserDefaults.standard.value(forKey: USER_ID) as! Int, email: UserDefaults.standard.value(forKey: EMAIL) as! String, username: UserDefaults.standard.value(forKey: USERNAME) as! String)
    }

}
