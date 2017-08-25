//
//  APIManager.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 7/29/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import Foundation
import Alamofire
import CryptoSwift
import SwiftyJSON
import AlamofireSwiftyJSON

class APIManager {
 
    static let shared = APIManager()
    static let baseUrl: String = "http://\(WORK_IP_ADDRESS_TWO):\(LOCAL_HOST_PORT)"
//    static let baseUrl: String = SERVER_DOMAIN
    static let createUser: String =  baseUrl + "/user"
    static let authenticate: String = baseUrl + "/authenticate"
    static let createPost: String = baseUrl + "/post"
    
    func createUser(email: String, username: String, password: String, avatar: Data?, Success: @escaping ((User) -> Void), Failure: @escaping ((String?) -> Void)) {
        
        let now = Date()
        
        var params = [
            "email": email,
            "username": username,
            "password": password,
            "aesKey": AES_KEY.toHexString(),
            "created": now,
            "updated": now
        ] as [String : Any]
        
        if avatar != nil {
            params["avatar"] = avatar
        }
        
        let url = URL(string: APIManager.createUser)!
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseSwiftyJSON { res in
            
            guard let json = res.result.value, json["userId"].int != nil, res.response?.statusCode == 200 else {
                
                if res.result.value == nil {
                    print(Error.noData)
                    Failure(res.result.value?["error"].string!)
                } else if res.response?.statusCode == 401 {
                    print(Error.unauthorized)
                    Failure(res.result.value?["error"].string!)
                } else if res.response?.statusCode == 409 {
                    print(Error.badRequest)
                    Failure(res.result.value?["error"].string!)
                } else if res.response?.statusCode == 500 {
                    print(Error.internalServerError)
                    Failure(res.result.value?["error"].string!)
                } else {
                    print(Error.unknownError)
                    Failure(res.result.value?["error"].string!)
                }
                return
            }
            let user = User(id: json["userId"].int!, json: json)
            UserCD.save(user: user)
            Success(user)
        }
    }
    
    func authenticate(email: String, password: String, Success: @escaping ((User) -> Void), Failure: @escaping ((String?) -> Void)) {
        
        let params = [
            "email": email,
            "password": password,
            "aesKey": AES_KEY.toHexString()
        ] as [String : Any]

        let url = URL(string: APIManager.authenticate)!
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseSwiftyJSON { res in
            
            guard let json = res.result.value, json["userId"].int != nil, res.response?.statusCode == 200 else {
                
                if res.result.value == nil {
                    print(Error.noData)
                    Failure(res.result.value?["error"].string!)
                } else if res.response?.statusCode == 401 {
                    print(Error.unauthorized)
                    Failure(res.result.value?["error"].string!)
                } else if res.response?.statusCode == 409 {
                    print(Error.badRequest)
                    Failure(res.result.value?["error"].string!)
                } else if res.response?.statusCode == 500 {
                    print(Error.internalServerError)
                    Failure(res.result.value?["error"].string!)
                } else {
                    print(Error.unknownError)
                    Failure(res.result.value?["error"].string!)
                }
                return
            }
            Success(User(id: json["userId"].int!, json: json))
        }
    }
    
    func createPost(text: String?, link: String?, image: String?, video: String?, audio: String?, type: PostType, Success: @escaping ((Post) -> Void), Failure: @escaping ((String?) -> Void)) {
        
        var params = [
            "user_id": User.currentId,
            "type": type.rawValue,
            "aesKey": AES_KEY.toHexString()
        ] as [String : Any]
        
        if text != nil {
            params["text"] = text
        }
        if link != nil {
            params["link"] = link
        }
        if image != nil {
            params["image"] = image
        }
        if video != nil {
            params["video"] = video
        }
        if audio != nil {
            params["audio"] = audio
        }
        
        let url = URL(string: APIManager.createPost)!
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseSwiftyJSON { res in

            guard let json = res.result.value, json["postId"].int != nil, res.response?.statusCode == 200 else {
                
                if res.result.value == nil {
                    print(Error.noData)
                    Failure(res.result.value?["error"].string!)
                } else if res.response?.statusCode == 401 {
                    print(Error.unauthorized)
                    Failure(res.result.value?["error"].string!)
                } else if res.response?.statusCode == 409 {
                    print(Error.badRequest)
                    Failure(res.result.value?["error"].string!)
                } else if res.response?.statusCode == 500 {
                    print(Error.internalServerError)
                    Failure(res.result.value?["error"].string!)
                } else {
                    print(Error.unknownError)
                    Failure(res.result.value?["error"].string!)
                }
                return
            }
            let post = Post(id: json["postId"].int!, json: json)
            PostCD.save(post: post)
            Success(post)
        }
    }

}
