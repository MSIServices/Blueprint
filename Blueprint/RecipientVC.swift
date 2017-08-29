//
//  RecipientVC.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/18/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import UIKit
import SwiftyGif
import AWSS3
import Photos

fileprivate let HEADER_TVC = "HeaderTVC"
fileprivate let CHECKBOX_TVC = "CheckboxTVC"
fileprivate let DESCRIPTION_TVC = "DescriptionTVC"

class RecipientVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CheckboxDelegate, SwiftyGifDelegate {

    @IBOutlet var mainV: MainV!
    @IBOutlet weak var tableView: UITableView!
    
    var checkedOptions = ["Connections"]
    var titles = ["Abyss", "Connections"]
    var groups = [Group]()
    var type: PostType!
    var videoExt: String?
    var text: String?
    var link: String?
    var imageLocalIdentifier: String?
    var videoUrl: URL?
    var videoThumbnail: UIImage?
    var videoAsset: PHAsset?
    var audioUrl: NSURL?
    var progressAlert: ProgressV!
    var successAlert: ZeroActionAlertV!
    var errorAlert: SingleActionAlertV!
    var previousVC: String!
    var awsManager: AWSS3TransferManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        awsManager = AWSS3TransferManager.default()
        
        let descriptionLbl = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 200))
        descriptionLbl.text = "Select recipients for the current post."
        descriptionLbl.textAlignment = .center
        descriptionLbl.textColor = UIColor.white
        descriptionLbl.font = UIFont(name: "OpenSans-Light", size: 14)!
        
        tableView.register(HeaderTVC.nib(), forCellReuseIdentifier: HEADER_TVC)
        tableView.register(CheckboxTVC.nib(), forCellReuseIdentifier: CHECKBOX_TVC)
        tableView.tableFooterView = descriptionLbl
        
        addBarButton(imageNormal: "back-white", imageHighlighted: nil, action: #selector(backBtnPressed), side: .west)
    }
    
    func dismissAlert() {
        mainV.removeAlert()
    }
    
    func update(name: String) {
        
        if !checkedOptions.contains(name) {
            checkedOptions.append(name)
        } else {
            let index = checkedOptions.index(of: name)
            checkedOptions.remove(at: index!)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if groups.count == 0 {
            return 1
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return titles.count
        }
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: HEADER_TVC) as! HeaderTVC
            
            cell.configureCell(title: "Options", image: "forward-arrow-cream")
            
            return cell.contentView
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: HEADER_TVC) as! HeaderTVC
            
            cell.configureCell(title: "Groups", image: "group-cream")
            
            return cell.contentView
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let title = titles[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: CHECKBOX_TVC) as! CheckboxTVC
            
            cell.configureCell(title: title)
            cell.checkboxDelegate = self
            
            return cell
            
        } else {
            
            let group = groups[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: CHECKBOX_TVC) as! CheckboxTVC
            
            cell.configureGroup(group: group)
            cell.checkboxDelegate = self
            
            return cell
        }
    }
    
    func backBtnPressed() {
        
        switch previousVC {
        case TEXT_VC:
            performSegue(withIdentifier: UNWIND_TEXT_VC, sender: self)
        case LINK_VC:
            performSegue(withIdentifier: UNWIND_LINK_VC, sender: self)
        case MEDIA_VC:
            performSegue(withIdentifier: UNWIND_MEDIA_VC, sender: self)
        default: break
        }
    }
    
    func gifDidLoop(sender: UIImageView) {
        
        dismissAlert()
        performSegue(withIdentifier: UNWIND_NEW_POST_VC, sender: self)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SwitchTab"), object: nil, userInfo: ["index":0])
    }
    
    func createPost(image: String?, video: String?, audio: String?) {
        
        APIManager.shared.createPost(text: text, link: link, image: image, video: video, audio: audio, type: type, Success: { _ in
        
            self.successAlert = self.mainV.showSuccess(msg: "", animated: true)
            self.successAlert.iconImageView.delegate = self
        
        }, Failure: { error in
        
            if let msg = error {
                self.errorAlert = self.mainV.showError(msg: msg, animated: true)
                self.errorAlert.confirmationBtn.addTarget(self, action: #selector(self.dismissAlert), for: .touchUpInside)
            }
        })
    }
    
    func uploadImageToS3(image: UIImage, ext: String, completion: @escaping ((URL?, NSError?) -> Void)) {
        
        let imageUploadRequest = AWSS3TransferManagerUploadRequest()
        imageUploadRequest?.bucket = S3_BUCKET
        
        var data: Data?

        if ext == "jpeg" {
            imageUploadRequest?.contentType = "image/jpeg"
            data = UIImageJPEGRepresentation(image, 1.0)
        } else if ext == "png" {
            imageUploadRequest?.contentType = "image/png"
            data = UIImagePNGRepresentation(image)
        }
        
        let imageFileName = ProcessInfo.processInfo.globallyUniqueString.appending(".\(ext)")
        let imageFileURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(imageFileName)
        
        do {
            try data?.write(to: imageFileURL!, options: .atomic)
            
            imageUploadRequest?.body = imageFileURL!
            imageUploadRequest?.key = imageFileName
            
            awsManager.upload(imageUploadRequest!).continueWith(block: { (task: AWSTask) -> Any? in
                
                if let error = task.error {
                    print("Upload image failed with error: (\(error))")
                    completion(nil, error as NSError)
                }
                
                if task.result != nil {
                    
                    let url = AWSS3.default().configuration.endpoint.url
                    let publicImageUrl = url?.appendingPathComponent((imageUploadRequest?.bucket!)!).appendingPathComponent((imageUploadRequest?.key!)!)
                    
                    completion(publicImageUrl, nil)
                }
                return nil
            })
            
            imageUploadRequest?.uploadProgress = { (bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) -> Void in
                
                DispatchQueue.main.async(execute: { () -> Void in
                    self.progressAlert.updateProgress(bytesSent: totalBytesSent, bytesExpected: totalBytesExpectedToSend)
                })
            }
        } catch let err as NSError {
            print("IMAGE WRITE ERROR: \(err)")
        }
    }
    
    func uploadVideoToS3(videoData: Data, ext: String, completion: @escaping ((URL?, NSError?) -> Void)) {
        
        let videoUploadRequest = AWSS3TransferManagerUploadRequest()
        videoUploadRequest?.bucket = S3_BUCKET
            
        if ext.uppercased() == "MOV" {
            videoUploadRequest?.contentType = "video/mov"
        }
        
        let videoFileName = ProcessInfo.processInfo.globallyUniqueString.appending(".\(ext)")
        let videoFileURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(videoFileName)
            
        do {
            try videoData.write(to: videoFileURL!, options: .atomic)
                
            videoUploadRequest?.body = videoFileURL!
            videoUploadRequest?.key = videoFileName
            
            awsManager.upload(videoUploadRequest!).continueWith(block: { (task: AWSTask) -> Any? in
                    
                if let error = task.error {
                    print("Upload video failed with error: (\(error))")
                    completion(nil, error as NSError)
                }
                
                if task.result != nil {
                        
                    let url = AWSS3.default().configuration.endpoint.url
                    let publicVideoURL = url?.appendingPathComponent((videoUploadRequest?.bucket!)!).appendingPathComponent((videoUploadRequest?.key!)!)
                    
                    completion(publicVideoURL, nil)
                }
                return nil
            })
                
            videoUploadRequest?.uploadProgress = {(bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) -> Void in
                    
                DispatchQueue.main.async(execute: { () -> Void in
                    self.progressAlert.updateProgress(bytesSent: totalBytesSent, bytesExpected: totalBytesExpectedToSend)
                })
            }
        } catch let err as NSError {
            print(err)
        }
    }
    
    @IBAction func createBtnPressed(_ sender: Any) {
        
        if checkedOptions.count > 0 {
            
            if type == PostType.image {
                
                let asset = PHAsset.fetchAssets(withLocalIdentifiers: [imageLocalIdentifier!], options: nil).firstObject!
                
                MediaManager.shared.fetchImage(asset: asset, completion: { (image, _, ext) in
                    
                    self.progressAlert = self.mainV.showProgressV(animated: true)
                    self.progressAlert.titleLbl.text = "Uploading Image"

                    self.uploadImageToS3(image: image, ext: ext, completion: { (url, error) in
                        
                        if url != nil {
                            self.createPost(image: String(describing: url!), video: nil, audio: nil)
                        } else {
                            print("Failed to get image url from s3 upload")
                        }
                        
                        DispatchQueue.main.async {
                            self.progressAlert.removeFromSuperview()
                        }
                    })
                })
            } else if type == PostType.video {
                
                MediaManager.shared.fetchVideo(asset: videoAsset!, getData: true, completion: { (_, data) in
                    
                    DispatchQueue.main.async {
                        self.progressAlert = self.mainV.showProgressV(animated: true)
                        self.progressAlert.titleLbl.text = "Uploading Video"
                    }
                    
                    self.uploadVideoToS3(videoData: data!, ext: self.videoExt!, completion: { (videoUrl, error) in
                        
                        if error != nil {
                            print(error!)
                        } else {
                                
                            DispatchQueue.main.async {
                                self.progressAlert.progressBarV.setProgress(0.0, animated: false)
                                self.progressAlert.titleLbl.text = "Uploading Thumbnail"
                            }
                            
                            self.uploadImageToS3(image: self.videoThumbnail!, ext: self.videoExt!, completion: { (imageUrl, error) in
                                    
                                if error != nil {
                                    print(error!)
                                } else {
                                    self.createPost(image: String(describing: imageUrl!), video: String(describing: videoUrl!), audio: nil)
                                }
                                    
                                DispatchQueue.main.async {
                                    self.progressAlert.removeFromSuperview()
                                }
                            })
                        }
                    })
                })
            }
        } else {
            self.errorAlert = self.mainV.showError(msg: "No recipients selected.", animated: true)
            self.errorAlert.confirmationBtn.addTarget(self, action: #selector(self.dismissAlert), for: .touchUpInside)
        }
    }

}
 
