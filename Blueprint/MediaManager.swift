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
    
    private let imageManager = PHImageManager()
    private let cacheImageManager = PHCachingImageManager()
    
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
    
    func fetchAllImageAssetsAndCache(Success: @escaping (([PHAsset]) -> Void), Failure: @escaping ((PHAuthorizationStatus) -> Void)) {
        
        PHPhotoLibrary.requestAuthorization { (status) in
            
            switch status {
            case .authorized:

                let fetchOptions = PHFetchOptions()
                let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                
                var assets: [PHAsset] = []
                
                allPhotos.enumerateObjects({ (asset, count, _) in
                    assets.append(asset)
                })
                
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                options.deliveryMode = .highQualityFormat
                
                self.cacheImageManager.startCachingImages(for: assets, targetSize: CGSize(width: UIScreen.main.bounds.size.width / 3 - 8, height: UIScreen.main.bounds.size.width / 3 - 8), contentMode: PHImageContentMode.aspectFill, options: options)
                
                Success(assets)
                
            case .denied:
                Failure(.denied)
            case .restricted:
                Failure(.restricted)
            case .notDetermined:
                Failure(.notDetermined)
            }
        }
    }
    
    func fetchImage(asset: PHAsset, completion: @escaping ((UIImage) -> Void)) {
        
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        options.deliveryMode = .highQualityFormat
        
        imageManager.requestImage(for: asset, targetSize: CGSize(width: UIScreen.main.bounds.size.width / 3 - 8, height: UIScreen.main.bounds.size.width / 3 - 8), contentMode: PHImageContentMode.aspectFill, options: options, resultHandler: { (image,info) in
                completion(image!)
        })
    }
    
    func fetchCachedImage(asset: PHAsset, Success: @escaping ((UIImage) -> Void), Failure: @escaping (() -> Void)) {
        
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        options.deliveryMode = .highQualityFormat

        cacheImageManager.requestImage(for: asset, targetSize: CGSize(width: UIScreen.main.bounds.size.width / 3 - 8, height: UIScreen.main.bounds.size.width / 3 - 8), contentMode: PHImageContentMode.aspectFill, options: options, resultHandler: { (image, info) in
            
            if let img = image {
                Success(img)
            } else {
                Failure()
            }
        })
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
