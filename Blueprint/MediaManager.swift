//
//  MediaManager.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/22/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import Foundation
import Alamofire

class MediaManager {
    
    static let shared = MediaManager()
    
    func getImage(urlString: String, Success: @escaping ((Data) -> Void), Failure: @escaping ((String) -> Void)) {
        
        let url = URL(string: urlString)!
        Alamofire.request(url).responseData { res in
         
            guard let data = res.data else {
                
                if res.data == nil {
                    print(Error.noData)
                    Failure(Error.noData.rawValue)
                } else if res.response?.statusCode == 401 {
                    print(Error.unauthorized)
                    Failure(Error.unauthorized.rawValue)
                } else if res.response?.statusCode == 409 {
                    print(Error.badRequest)
                    Failure(Error.badRequest.rawValue)
                } else if res.response?.statusCode == 500 {
                    print(Error.internalServerError)
                    Failure(Error.internalServerError.rawValue)
                } else {
                    print(Error.unknownError)
                    Failure(Error.unknownError.rawValue)
                }
                return
            }
            Success(data)
        }
    }
    
//    func getImageFromS3AndCache(email: String, password: String, Success: @escaping ((User) -> Void), Failure: @escaping ((String?) -> Void)) {
//        
//        let params = [
//            "email": email,
//            "password": password,
//            "aesKey": AES_KEY.toHexString()
//            ] as [String : Any]
//        
//        let url = URL(string: APIManager.authenticate)!
//        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).response { res in
//            
//            print(res)
//            
//            guard let data = res.data, res.response?.statusCode == 200 else {
//                
//                if res.data == nil {
//                    print(Error.noData)
//                    Failure(Error.noData.rawValue)
//                } else if res.response?.statusCode == 401 {
//                    print(Error.unauthorized)
//                    Failure(Error.unauthorized.rawValue)
//                } else if res.response?.statusCode == 409 {
//                    print(Error.badRequest)
//                    Failure(Error.badRequest.rawValue)
//                } else if res.response?.statusCode == 500 {
//                    print(Error.internalServerError)
//                    Failure(Error.internalServerError.rawValue)
//                } else {
//                    print(Error.unknownError)
//                    Failure(Error.unknownError.rawValue)
//                }
//                return
//            }
//        }
//    }

}
