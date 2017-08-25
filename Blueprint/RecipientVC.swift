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
    var titles = ["Abyss","Connections"]
    var groups = [Group]()
    var type: PostType!
    var ext: String?
    var text: String?
    var link: String?
    var imageUrl: NSURL?
    var imageLocalIdentifier: String?
    var videoUrl: NSURL?
    var audioUrl: NSURL?
    var progressAlert: ProgressV!
    var successAlert: ZeroActionAlertV!
    var errorAlert: SingleActionAlertV!
    var previousVC: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    @IBAction func createBtnPressed(_ sender: Any) {
        
        if checkedOptions.count > 0 {
            
            if type == PostType.image || type == PostType.video || type == PostType.audio {
                
                let awsManager = AWSS3TransferManager.default()
                
                let uploadRequest = AWSS3TransferManagerUploadRequest()
                uploadRequest?.bucket = S3_BUCKET
                
                var data: Data?
                
                if imageLocalIdentifier != nil {
                    
                    let asset = PHAsset.fetchAssets(withLocalIdentifiers: [imageLocalIdentifier!], options: nil).firstObject!

                    MediaManager.shared.fetchImage(asset: asset, completion: { (image, url, ext) in
                        
                        if ext == "jpeg" {
                            uploadRequest?.contentType = "image/jpeg"
                            data = UIImageJPEGRepresentation(image, 1.0)
                        } else if ext == "png" {
                            uploadRequest?.contentType = "image/png"
                            data = UIImagePNGRepresentation(image)
                        }
                        
                        let fileName = ProcessInfo.processInfo.globallyUniqueString.appending(".\(ext)")
                        let fileURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
                        
                        do {
                            
                            try data?.write(to: fileURL!, options: .atomic)
                            
                            uploadRequest?.body = fileURL!
                            uploadRequest?.key = fileName
                            
                            self.progressAlert = self.mainV.showProgressV(animated: true)

                            awsManager.upload(uploadRequest!).continueWith(block: { (task: AWSTask) -> Any? in
                                    
                                if let error = task.error {
                                    print("Upload failed with error: (\(error))")
                                }
                                
                                if task.result != nil {
                                        
                                    let url = AWSS3.default().configuration.endpoint.url
                                    let publicURL = url?.appendingPathComponent((uploadRequest?.bucket!)!).appendingPathComponent((uploadRequest?.key!)!)
                                    
                                    self.createPost(image: "\(publicURL!)", video: nil, audio: nil)
                                    
                                    DispatchQueue.main.async {
                                        self.progressAlert.removeFromSuperview()
                                    }
                                }
                                return nil
                            })
                            
                            uploadRequest?.uploadProgress = {(bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) -> Void in
                                
                                DispatchQueue.main.async(execute: { () -> Void in
                                    self.progressAlert.updateProgress(bytesSent: totalBytesSent, bytesExpected: totalBytesExpectedToSend)
                                })
                            }
                       
                        } catch let err as NSError {
                            print("IMAGE WRITE ERROR: \(err)")
                        }
                    })
                }
            }
        } else {
            self.errorAlert = self.mainV.showError(msg: "No recipients selected.", animated: true)
            self.errorAlert.confirmationBtn.addTarget(self, action: #selector(self.dismissAlert), for: .touchUpInside)
        }
    }

}
