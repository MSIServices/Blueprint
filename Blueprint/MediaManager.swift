//
//  MediaManager.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/22/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import Foundation
import Photos
import Alamofire

class MediaManager {
    
    static let shared = MediaManager()
    
    private let imageManager = PHImageManager.default()
    
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
    
    func getAllPhotos(Success: @escaping (([UIImage]) -> Void), Failure: @escaping ((PHAuthorizationStatus) -> Void)) {
     
        var photos = [UIImage]()
        let myGroup = DispatchGroup()
        
        PHPhotoLibrary.requestAuthorization { (status) in
            
            switch status {
            case .authorized:

                let fetchOptions = PHFetchOptions()
                let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)

                let imageManagerOptions = PHImageRequestOptions()
                imageManagerOptions.deliveryMode = .highQualityFormat
                
                allPhotos.enumerateObjects({ (asset, count, _) in
                    
                    myGroup.enter()
                    
                    self.imageManager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: PHImageContentMode.default, options: imageManagerOptions, resultHandler: { (image, info) in
                        
                        photos.append(image!)
                        
                        myGroup.leave()
                    })
                })
                
                myGroup.notify(queue: DispatchQueue.main, execute: {
                    Success(photos)
                })
        
            case .denied:
                Failure(.denied)
            case .restricted:
                Failure(.restricted)
            case .notDetermined:
                Failure(.notDetermined)
            }
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
