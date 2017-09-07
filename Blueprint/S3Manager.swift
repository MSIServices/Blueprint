//
//  S3Manager.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 9/6/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import Foundation
import AWSS3

class S3Manager {
    
    static let shared = S3Manager()
    
    private var awsManager: AWSS3TransferManager = AWSS3TransferManager.default()
    
    func uploadImageToS3(imageUploadRequest: AWSS3TransferManagerUploadRequest, image: UIImage, ext: String, completion: @escaping ((URL?, NSError?) -> Void)) {
        
        imageUploadRequest.bucket = S3_BUCKET
        
        var data: Data?
        
        if ext == "jpeg" {
            imageUploadRequest.contentType = "image/jpeg"
            data = UIImageJPEGRepresentation(image, 1.0)
        } else if ext == "png" {
            imageUploadRequest.contentType = "image/png"
            data = UIImagePNGRepresentation(image)
        }
        
        let imageFileName = ProcessInfo.processInfo.globallyUniqueString.appending(".\(ext)")
        let imageFileURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(imageFileName)
        
        do {
            try data?.write(to: imageFileURL!, options: .atomic)
            
            imageUploadRequest.body = imageFileURL!
            imageUploadRequest.key = imageFileName
            
            awsManager.upload(imageUploadRequest).continueWith(block: { (task: AWSTask) -> Any? in
                
                if let error = task.error {
                    print("Upload image failed with error: (\(error))")
                    completion(nil, error as NSError)
                }
                
                if task.result != nil {
                    
                    let url = AWSS3.default().configuration.endpoint.url
                    let publicImageUrl = url?.appendingPathComponent(imageUploadRequest.bucket!).appendingPathComponent(imageUploadRequest.key!)
                    
                    completion(publicImageUrl, nil)
                }
                return nil
            })
            
        } catch let err as NSError {
            print("IMAGE WRITE ERROR: \(err)")
        }
    }
    
    func uploadVideoToS3(videoUploadRequest: AWSS3TransferManagerUploadRequest, videoData: Data, ext: String, completion: @escaping ((URL?, NSError?) -> Void)) {
        
        videoUploadRequest.bucket = S3_BUCKET
        
        if ext.uppercased() == "MOV" {
            videoUploadRequest.contentType = "video/mov"
        }
        
        let videoFileName = ProcessInfo.processInfo.globallyUniqueString.appending(".\(ext)")
        let videoFileURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(videoFileName)
        
        do {
            try videoData.write(to: videoFileURL!, options: .atomic)
            
            videoUploadRequest.body = videoFileURL!
            videoUploadRequest.key = videoFileName
            
            awsManager.upload(videoUploadRequest).continueWith(block: { (task: AWSTask) -> Any? in
                
                if let error = task.error {
                    print("Upload video failed with error: (\(error))")
                    completion(nil, error as NSError)
                }
                
                if task.result != nil {
                    
                    let url = AWSS3.default().configuration.endpoint.url
                    let publicVideoURL = url?.appendingPathComponent(videoUploadRequest.bucket!).appendingPathComponent(videoUploadRequest.key!)
                    
                    completion(publicVideoURL, nil)
                }
                return nil
            })
        } catch let err as NSError {
            print(err)
        }
    }
    
    func uploadAudioToS3(audioUploadRequest: AWSS3TransferManagerUploadRequest, audioData: Data, ext: String, completion: @escaping ((URL?, NSError?) -> Void)) {
        
        audioUploadRequest.bucket = S3_BUCKET
        
        if ext == "wav" {
            audioUploadRequest.contentType = "audio/\(ext)"
        } else if ext == "m4a" {
            audioUploadRequest.contentType = "audio/\(ext)"
        }
        
        let audioFileName = ProcessInfo.processInfo.globallyUniqueString.appending(".\(ext)")
        let audioFileURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(audioFileName)
        
        do {
            try audioData.write(to: audioFileURL!, options: .atomic)
            
            audioUploadRequest.body = audioFileURL!
            audioUploadRequest.key = audioFileName
            
            awsManager.upload(audioUploadRequest).continueWith(block: { (task: AWSTask) -> Any? in
                
                if let error = task.error {
                    print("Upload image failed with error: (\(error))")
                    completion(nil, error as NSError)
                }
                
                if task.result != nil {
                    
                    let url = AWSS3.default().configuration.endpoint.url
                    let publicAudioUrl = url?.appendingPathComponent(audioUploadRequest.bucket!).appendingPathComponent(audioUploadRequest.key!)
                    
                    completion(publicAudioUrl, nil)
                }
                return nil
            })
            
        } catch let err as NSError {
            print("IMAGE WRITE ERROR: \(err)")
        }
    }

}
