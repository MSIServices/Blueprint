//
//  APIManager.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 7/29/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import Foundation
import AlamofireSwiftyJSON
import Alamofire
//import CryptoSwift

class APIManager {
    
    static let shared = APIManager()
    static let baseUrl: String = "http://\(WORK_IP_ADDRESS_ONE):\(LOCAL_HOST_PORT)"
//    static let baseUrl: String = SERVER_DOMAIN
    static let createUser: String =  baseUrl + "/user"
    static let users: String = baseUrl + "/users"
    static let authenticate: String = baseUrl + "/authenticate"
    static let createPost: String = baseUrl + "/post"
    static let conversation: String = baseUrl + "/conversation"
    static let conversationMessages: String = baseUrl + "/conversation/messages"
    static let conversationMessage: String = baseUrl + "/conversation/message"
    static let conversationParticipantsMessage: String = baseUrl + "/conversation/participants/message"
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
                    print(ServerError.noData)
                    Failure(res.result.value?["error"].string!)
                } else if res.response?.statusCode == 401 {
                    print(ServerError.unauthorized)
                    Failure(res.result.value?["error"].string!)
                } else if res.response?.statusCode == 409 {
                    print(ServerError.badRequest)
                    Failure(res.result.value?["error"].string!)
                } else if res.response?.statusCode == 500 {
                    print(ServerError.internalServerError)
                    Failure(res.result.value?["error"].string!)
                } else {
                    print(ServerError.unknownError)
                    Failure(res.result.value?["error"].string!)
                }
                return
            }
            let user = User(json: json)
            if UserCD.fetchById(UserId: user.userId!) == nil {
                UserCD.save(user: user)
            }
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
                    print(ServerError.noData)
                    Failure(res.result.value?["error"].string!)
                } else if res.response?.statusCode == 401 {
                    print(ServerError.unauthorized)
                    Failure(res.result.value?["error"].string!)
                } else if res.response?.statusCode == 409 {
                    print(ServerError.badRequest)
                    Failure(res.result.value?["error"].string!)
                } else if res.response?.statusCode == 500 {
                    print(ServerError.internalServerError)
                    Failure(res.result.value?["error"].string!)
                } else {
                    print(ServerError.unknownError)
                    Failure(res.result.value?["error"].string!)
                }
                return
            }
            let user = User(json: json)
            if UserCD.fetchById(UserId: user.userId!) == nil {
                UserCD.save(user: user)
            }
            Success(user)
        }
    }
    
    func getUsers(Success: @escaping (([UserCD]) -> Void), Failure: @escaping ((String?) -> Void)) {
        
        let url = URL(string: APIManager.users)!
        Alamofire.request(url).responseSwiftyJSON { res in
            
            guard let jsonArray = res.result.value?.array, jsonArray.count > 0, res.response?.statusCode == 200 else {
                
                if res.result.value?.array == nil {
                    print(ServerError.noData)
                    Failure(res.result.value?["error"].string!)
                } else if res.response?.statusCode == 401 {
                    print(ServerError.unauthorized)
                    Failure(res.result.value?["error"].string!)
                } else if res.response?.statusCode == 409 {
                    print(ServerError.badRequest)
                    Failure(res.result.value?["error"].string!)
                } else if res.response?.statusCode == 500 {
                    print(ServerError.internalServerError)
                    Failure(res.result.value?["error"].string!)
                } else {
                    print(ServerError.unknownError)
                    Failure(res.result.value?["error"].string!)
                }
                return
            }
            for user in jsonArray {
                
                let user = User(json: user)
                if UserCD.fetchById(UserId: user.userId!) == nil {
                    UserCD.save(user: user)
                }
            }
            Success(UserCD.fetchAll())
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
                    print(ServerError.noData)
                    Failure(res.result.value?["error"].string!)
                } else if res.response?.statusCode == 401 {
                    print(ServerError.unauthorized)
                    Failure(res.result.value?["error"].string!)
                } else if res.response?.statusCode == 409 {
                    print(ServerError.badRequest)
                    Failure(res.result.value?["error"].string!)
                } else if res.response?.statusCode == 500 {
                    print(ServerError.internalServerError)
                    Failure(res.result.value?["error"].string!)
                } else {
                    print(ServerError.unknownError)
                    Failure(res.result.value?["error"].string!)
                }
                return
            }
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
                    print(ServerError.noData)
                    Failure(res.result.value?["error"].string!)
                } else if res.response?.statusCode == 401 {
                    print(ServerError.unauthorized)
                    Failure(res.result.value?["error"].string!)
                } else if res.response?.statusCode == 409 {
                    print(ServerError.badRequest)
                    Failure(res.result.value?["error"].string!)
                } else if res.response?.statusCode == 500 {
                    print(ServerError.internalServerError)
                    Failure(res.result.value?["error"].string!)
                } else {
                    print(ServerError.unknownError)
                    Failure(res.result.value?["error"].string!)
                }
                return
            }
            let conversation = Conversation(json: json, type: .detail)
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

            guard let json = res.result.value, res.response?.statusCode == 200 else {
                
                if res.result.value == nil {
                    print(ServerError.noData)
                    Failure(res.result.value?["error"].string!)
                } else if res.response?.statusCode == 401 {
                    print(ServerError.unauthorized)
                    Failure(res.result.value?["error"].string!)
                } else if res.response?.statusCode == 409 {
                    print(ServerError.badRequest)
                    Failure(res.result.value?["error"].string!)
                } else if res.response?.statusCode == 500 {
                    print(ServerError.internalServerError)
                    Failure(res.result.value?["error"].string!)
                } else {
                    print(ServerError.unknownError)
                    Failure(res.result.value?["error"].string!)
                }
                return
            }
            //You should never end up here unless your data is valid
            if json["result"].bool == false {
                Success(nil)
            } else {
                
                let conversation = Conversation(json: json, type: .detail)
                Success(ConversationCD.sync(conversation: conversation))
            }
        }
    }
    
    func getConversations(userId: NSNumber, Success: @escaping (([ConversationCD]) -> Void), Failure: @escaping ((String?) -> Void)) {
        
        let params = [
            "userId": userId,
            "aesKey": AES_KEY.toHexString()
        ] as [String:Any]
        
        let url = URL(string: APIManager.conversations)!
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseSwiftyJSON { res in
            
            guard let jsonArray = res.result.value?.array, res.response?.statusCode == 200 else {
                
                if res.result.value == nil {
                    print(ServerError.noData)
                    Failure(res.result.value?["error"].string!)
                } else if res.response?.statusCode == 401 {
                    print(ServerError.unauthorized)
                    Failure(res.result.value?["error"].string!)
                } else if res.response?.statusCode == 409 {
                    print(ServerError.badRequest)
                    Failure(res.result.value?["error"].string!)
                } else if res.response?.statusCode == 500 {
                    print(ServerError.internalServerError)
                    Failure(res.result.value?["error"].string!)
                } else {
                    print(ServerError.unknownError)
                    Failure(res.result.value?["error"].string!)
                }
                return
            }
            var conversations = [ConversationCD]()
            
            for convo in jsonArray {
                
                let conversation = Conversation(json: convo, type: .preview)
                conversations.append(ConversationCD.sync(conversation: conversation)!)
            }
            Success(conversations)
        }
    }
    
    func getConversationMessages(conversationId: NSNumber, Success: @escaping ((ConversationCD) -> Void), Failure: @escaping ((String?) -> Void)) {
        
        let url = createUrlWithQueryStrings(url: APIManager.conversationMessages, parameters: [[0:"conversationId" as AnyObject,1:conversationId]])
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseSwiftyJSON { res in
            
            guard let jsonArray = res.result.value?.array, res.response?.statusCode == 200 else {
                
                if res.result.value == nil {
                    print(ServerError.noData)
                    Failure(res.result.value?["error"].string!)
                } else if res.response?.statusCode == 401 {
                    print(ServerError.unauthorized)
                    Failure(res.result.value?["error"].string!)
                } else if res.response?.statusCode == 409 {
                    print(ServerError.badRequest)
                    Failure(res.result.value?["error"].string!)
                } else if res.response?.statusCode == 500 {
                    print(ServerError.internalServerError)
                    Failure(res.result.value?["error"].string!)
                } else {
                    print(ServerError.unknownError)
                    Failure(res.result.value?["error"].string!)
                }
                return
            }
            let conversation = ConversationCD.fetch(conversationId: conversationId)
            
            for msg in jsonArray {
                
                let message = Message(message: msg)
                let sender = UserCD.fetchById(UserId: msg["userId"].number!)
                MessageCD.save(message: message, conversation: conversation!, sender: sender!)
            }
            Success(ConversationCD.fetch(conversationId: conversationId)!)
        }
    }
    
        func saveMessageToConversation(conversationId: NSNumber, message: String, senderId: NSNumber, Success: @escaping ((ConversationCD) -> Void), Failure: @escaping ((String?) -> Void)) {
            
            let params = [
                "senderId": senderId,
                "message": message,
                "conversationId": conversationId,
                "aesKey": AES_KEY.toHexString()
            ] as [String:Any]
    
            let url = URL(string: APIManager.conversationMessage)!
            Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseSwiftyJSON { res in
                
                guard let json = res.result.value, res.response?.statusCode == 200 else {
    
                    if res.result.value == nil {
                        print(ServerError.noData)
                        Failure(res.result.value?["error"].string!)
                    } else if res.response?.statusCode == 401 {
                        print(ServerError.unauthorized)
                        Failure(res.result.value?["error"].string!)
                    } else if res.response?.statusCode == 409 {
                        print(ServerError.badRequest)
                        Failure(res.result.value?["error"].string!)
                    } else if res.response?.statusCode == 500 {
                        print(ServerError.internalServerError)
                        Failure(res.result.value?["error"].string!)
                    } else {
                        print(ServerError.unknownError)
                    }
                    return
                }
                let conversation = Conversation(json: json, type: .detail)
                Success(ConversationCD.sync(conversation: conversation)!)
            }
        }
    
//    func saveMessageToConversationWithAdditionalRecipients(conversationId: NSNumber, message: String, senderId: NSNumber, participants: [NSNumber], Success: @escaping ((ConversationCD) -> Void), Failure: @escaping ((String?) -> Void)) {
//        
//        let params = [
//            "senderId": senderId,
//            "message": message,
//            "conversationId": conversationId,
//            "participants": participants,
//            "aesKey": AES_KEY.toHexString()
//        ] as [String:Any]
//        
//        let url = URL(string: APIManager.conversationParticipantsMessage)!
//        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseSwiftyJSON { res in
//            
//            guard let jsonArray = res.result.value?.array, res.response?.statusCode == 200 else {
//                
//                if res.result.value == nil {
//                    print(ServerError.noData)
//                    Failure(res.result.value?["error"].string!)
//                } else if res.response?.statusCode == 401 {
//                    print(ServerError.unauthorized)
//                    Failure(res.result.value?["error"].string!)
//                } else if res.response?.statusCode == 409 {
//                    print(ServerError.badRequest)
//                    Failure(res.result.value?["error"].string!)
//                } else if res.response?.statusCode == 500 {
//                    print(ServerError.internalServerError)
//                    Failure(res.result.value?["error"].string!)
//                } else {
//                    print(ServerError.unknownError)
//                    Failure(res.result.value?["error"].string!)
//                }
//                return
//            }
//            let conversation = ConversationCD.fetch(conversationId: conversationId)
//            
//            for msg in jsonArray {
//                
//                let message = Message(message: msg)
//                let sender = UserCD.fetchById(UserId: msg["userId"].number!)
//                MessageCD.save(message: message, conversation: conversation!, sender: sender!)
//            }
//            Success(ConversationCD.fetch(conversationId: conversationId)!)
//        }
//    }
    
}

extension APIManager {
    
    func createUrlWithQueryStrings(url: String, parameters: [[Int : Any]]) -> URL {
        
        var firstParameter = true
        var url = url
        
        for param in parameters {
            
            if firstParameter {
                
                firstParameter = false
                url.append("?\(param[0]!)=\(param[1]!)")
                
            } else {
                url.append("&\(param[0]!)=\(param[1]!)")
            }
        }
        return URL(string: url)!
    }
    
}
