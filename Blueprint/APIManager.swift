//
//  APIManager.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 7/29/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireSwiftyJSON
import CryptoSwift

class APIManager {
    
    static let shared = APIManager()
    static let baseUrl: String = "http://\(WORK_IP_ADDRESS_ONE):\(LOCAL_HOST_PORT)"
//    static let baseUrl: String = SERVER_DOMAIN
    static let createUser: String =  baseUrl + "/user"
    static let users: String = baseUrl + "/users"
    static let authenticate: String = baseUrl + "/authenticate"
    static let createPost: String = baseUrl + "/post"
    static let conversation: String = baseUrl + "/conversation"
    static let conversations: String = baseUrl + "/conversations"
    static let conversationFromParticipants: String = baseUrl + "/participants/conversation"
    
    func createUser(email: String, username: String, password: String, avatar: Data?, Success: @escaping ((User) -> Void), Failure: @escaping ((String?) -> Void)) {
        
        var params = [
            "email": email,
            "username": username,
            "password": password,
            "aesKey": AES_KEY.toHexString()
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
            //You should never end up here unless your data is valid

            let user = User(json: json)
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
            //You should never end up here unless your data is valid

            Success(User(json: json))
        }
    }
    
    func getUsers(Success: @escaping ((Bool) -> Void), Failure: @escaping ((String?) -> Void)) {
        
        let url = URL(string: APIManager.users)!
        Alamofire.request(url).responseSwiftyJSON { res in
            
            guard let jsonArray = res.result.value?.array, jsonArray.count > 0, res.response?.statusCode == 200 else {
                
                if res.result.value?.array == nil {
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
            //You should never end up here unless your data is valid
            
            for user in jsonArray {
                
                let user = User(json: user)
                UserCD.save(user: user)
            }
            Success(true)
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
            //You should never end up here unless your data is valid

            let post = Post(id: json["postId"].int!, json: json)
            PostCD.save(post: post)
            Success(post)
        }
    }
    
    func createConversation(message: String, recipients: [NSNumber], Success: @escaping ((ConversationCD) -> Void), Failure: @escaping ((String?) -> Void)) {
        
        let params = [
            "message": message,
            "recipients": recipients,
            "aesKey": AES_KEY.toHexString()
        ] as [String : Any]
        
        let url = URL(string: APIManager.conversation)!
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseSwiftyJSON { res in

            guard let json = res.result.value, res.response?.statusCode == 200 else {
                
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
            //You should never end up here unless your data is valid

            let conversation = Conversation(json: json)
            Success(ConversationCD.sync(conversation: conversation)!)
        }
    }

    func getConversationFromRecipients(recipients: [NSNumber], Success: @escaping ((ConversationCD?) -> Void), Failure: @escaping ((String?) -> Void)) {
        
        let params = [
            "recipients": recipients,
            "aesKey": AES_KEY.toHexString()
        ] as [String:Any]
        
        let url = URL(string: APIManager.conversationFromParticipants)!
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseSwiftyJSON { res in
            print(res)
            guard let json = res.result.value, res.response?.statusCode == 200 else {
                
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
            //You should never end up here unless your data is valid
            
            if json["result"].bool == false {
                Success(nil)
            } else {
                
                let conversation = Conversation(json: json)
                Success(ConversationCD.sync(conversation: conversation))
            }
        }
    }
    
    func getConversations(userId: String, Success: @escaping ((ConversationCD?) -> Void), Failure: @escaping ((String?) -> Void)) {
        
        let params = [
            "userId": userId,
            "aesKey": AES_KEY.toHexString()
            ] as [String:Any]
        
        let url = URL(string: APIManager.conversations)!
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseSwiftyJSON { res in
            print(res)
            guard let json = res.result.value, res.response?.statusCode == 200 else {
                
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

        }
    }

}
