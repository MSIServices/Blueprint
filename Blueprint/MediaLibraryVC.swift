//
//  MediaLibraryVC.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/23/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import UIKit
import Photos

fileprivate let SHOW_CAMERA_CVC = "ShowCameraCVC"
fileprivate let PHOTO_CVC = "PhotoCVC"

class MediaLibraryVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var mainV: MainV!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    let targetSize = CGSize(width: UIScreen.main.bounds.size.width / 3 - 8, height: UIScreen.main.bounds.size.width / 3 - 8)
    let imagePicker = UIImagePickerController()
    
    var settingsAlertV: DoubleActionAlertV!
    var photoAssets = [PHAsset]()
    var videoAssets = [PHAsset]()
    var selectedImage: UIImage!
    var selectedImageIdentifier: String?
    var selectedVideoAsset: PHAsset?
    var thumbnail: UIImage?
    var videoUrl: URL?
    var ext: String?
    var type: PostType!
    var previousVC: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            imagePicker.sourceType = .camera
            
            if type == .image {
                imagePicker.mediaTypes = ["public.image"]
            } else {
                imagePicker.mediaTypes = ["public.movie"]
            }
        }
        
        addBarButton(imageNormal: "back-white", imageHighlighted: nil, action: #selector(backBtnPressed), side: .west)

        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        
        collectionView.register(ShowCameraCVC.nib(), forCellWithReuseIdentifier: SHOW_CAMERA_CVC)
        collectionView.register(PhotoCVC.nib(), forCellWithReuseIdentifier: PHOTO_CVC)
        collectionView.collectionViewLayout = layout
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if type == .image {
            
            MediaManager.shared.fetchAllImageAssetsAndCache(Success:  { assets in
                
                DispatchQueue.main.async {
                    self.photoAssets = assets
                    self.collectionView.reloadData()
                }
                
            }, Failure: { status in
                
                self.settingsAlertV = self.mainV.showDoubleActionAlert(height: 250, width: 250, header: "Photo Library Access", subHeader: "Blueprint needs access to your photo library", cancelBtnText: "Cancel", confirmationBtnText: "Settings", backgroundColor: UIColor.white, buttonNormalBackgroundColor: UIColor.white, buttonHighlightedBackgroundColor: UIColor.lightGray, icon: nil, animated: true)
                self.settingsAlertV.addButtonBorder(color: UIColor.lightGray, thickness: 1.0)
                self.settingsAlertV.cancelBtn.addTarget(self, action: #selector(self.dismissAlert), for: .touchUpInside)
                self.settingsAlertV.confirmationBtn.addTarget(self, action: #selector(self.openSettings), for: .touchUpInside)
            })
        } else if type == .video {
            
            MediaManager.shared.fetchAllVideos(Success: { assets in

                DispatchQueue.main.async {
                    self.videoAssets = assets
                    self.collectionView.reloadData()
                }

            }, Failure: { status in
                
                self.settingsAlertV = self.mainV.showDoubleActionAlert(height: 250, width: 250, header: "Photo Library Access", subHeader: "Blueprint needs access to your photo library", cancelBtnText: "Cancel", confirmationBtnText: "Settings", backgroundColor: UIColor.white, buttonNormalBackgroundColor: UIColor.white, buttonHighlightedBackgroundColor: UIColor.lightGray, icon: nil, animated: true)
                self.settingsAlertV.addButtonBorder(color: UIColor.lightGray, thickness: 1.0)
                self.settingsAlertV.cancelBtn.addTarget(self, action: #selector(self.dismissAlert), for: .touchUpInside)
                self.settingsAlertV.confirmationBtn.addTarget(self, action: #selector(self.openSettings), for: .touchUpInside)
            })
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == UNWIND_MEDIA_VC && selectedImage != nil {
            
            let vC = segue.destination as! MediaVC
            vC.mediaImageView.image = selectedImage
            vC.newImageIdentifier = selectedImageIdentifier
            vC.thumbnail = thumbnail
            vC.videoExt = ext
            vC.videoUrl = videoUrl
            vC.selectedVideoAsset = selectedVideoAsset
            
        } else if segue.identifier == UNWIND_QUOTE_VC && selectedImage != nil {
            
            let vC = segue.destination as! QuoteVC
            vC.quoteImageView.image = selectedImage
            vC.selectedImageIdentifier = selectedImageIdentifier
        }
    }
    
    func dismissAlert() {
        mainV.removeAlert()
    }
    
    func openSettings() {
        
        let settingsUrl = URL(string: UIApplicationOpenSettingsURLString)!
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
               
                if success {
                    print("Successfully opened settings.")
                }
            })
        }
    }
    
    func backBtnPressed() {
        
        print(previousVC)
        
        switch previousVC {
        case MEDIA_VC:
            performSegue(withIdentifier: UNWIND_MEDIA_VC, sender: self)
        case QUOTE_VC:
            performSegue(withIdentifier: UNWIND_QUOTE_VC, sender: self)
        default:
            break
        }
    }

   func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        
        if error == nil {
            
            MediaManager.shared.fetchLastAssetLocalIdentifier(type: .image, completion: { urlString in
                
                self.selectedImageIdentifier = urlString
                backBtnPressed()
            })
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        if type == .image {
            
            selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            UIImageWriteToSavedPhotosAlbum(selectedImage, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
            
        } else if type == .video {
            
            if let url = info["UIImagePickerControllerMediaURL"] as? URL {
                
                let asset = AVURLAsset(url: url, options: nil)
                let imgGenerator = AVAssetImageGenerator(asset: asset)
                
                videoUrl = url
                ext = url.pathExtension
                
                MediaManager.shared.saveVideo(videoUrl: videoUrl!, completion: { result in
                
                    DispatchQueue.main.async {
                        
                        do {
                            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
                            self.thumbnail = UIImage(cgImage: cgImage, scale: CGFloat(1.0), orientation: .right)
                            self.selectedImage = self.thumbnail
                            
                            MediaManager.shared.fetchLastAsset(type: .video, completion: { asset in
                                
                                self.selectedVideoAsset = asset
                                self.backBtnPressed()
                            })
                        } catch let err as NSError {
                            print(err.debugDescription)
                        }
                    }
                })
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if type == PostType.image {
            return photoAssets.count + 1
        } else {
            return videoAssets.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var asset: PHAsset!

        if indexPath.row == 0 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SHOW_CAMERA_CVC, for: indexPath) as! ShowCameraCVC
            
            if type == .image {
                cell.configureCell(text: "Photo", image: "camera-white")
            } else if type == .video {
                cell.configureCell(text: "Video", image: "video-white")
            }
            return cell
            
        } else if type == PostType.image {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PHOTO_CVC, for: indexPath) as! PhotoCVC
            
            asset = photoAssets[(indexPath as NSIndexPath).row - 1]
                
            MediaManager.shared.fetchCachedImage(asset: asset, Success: { photo in
            
                cell.configureCell(image: photo)
                
            }, Failure: {
                    
                MediaManager.shared.fetchImage(asset: asset, targetSize: self.targetSize, completion: { photo in
                    cell.configureCell(image: photo)
                })
            })
            return cell
                
        } else if type == PostType.video {
            
            asset = videoAssets[(indexPath as NSIndexPath).row - 1]
                
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PHOTO_CVC, for: indexPath) as! PhotoCVC
                
            DispatchQueue.global(qos: .background).async {
                    
                MediaManager.shared.getAssetThumbnail(asset: asset, size: UIScreen.main.bounds.size.width / 3 - 8, completion: { image in
                    cell.configureCell(image: image!)
                })
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return targetSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row != 0 {
            
            if type == .image {
                
                let asset = photoAssets[(indexPath as NSIndexPath).row - 1]
                selectedImageIdentifier = asset.localIdentifier
                
                MediaManager.shared.fetchImage(asset: asset, completion: { (image, url, ext) in
                    self.selectedImage = image
                    self.backBtnPressed()
                })
            } else if type == .video {
                
                let asset = videoAssets[(indexPath as NSIndexPath).row - 1]
                selectedVideoAsset = asset
                
                MediaManager.shared.fetchVideo(asset: asset, getData: false, completion: { url, _ in
                    
                    self.videoUrl = url
                    self.ext = url?.pathExtension
                    
                    let asset = AVURLAsset(url: url!, options: nil)
                    let imgGenerator = AVAssetImageGenerator(asset: asset)
                    
                    DispatchQueue.main.async {
                        
                        do {
                            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
                            self.thumbnail = UIImage(cgImage: cgImage, scale: CGFloat(1.0), orientation: .right)
                            self.selectedImage = self.thumbnail
                            self.backBtnPressed()
                        
                        } catch let err as NSError {
                            print(err.debugDescription)
                        }
                    }
                })
            }
        } else {
            present(imagePicker, animated: true, completion: nil)
        }
    }

}
