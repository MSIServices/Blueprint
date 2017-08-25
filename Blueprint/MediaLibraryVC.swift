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
    var selectedImageUrl: NSURL?
    var selectedImageIdentifier: String?
    var ext: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
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
        
        
        if type == PostType.image {
            
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
        } else if type == PostType.video {
            
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
            vC.imagePath = selectedImageUrl
            vC.newImageIdentifier = selectedImageIdentifier
            vC.ext = ext
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
        performSegue(withIdentifier: UNWIND_MEDIA_VC, sender: self)
    }

   func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        
        if error == nil {
            
            MediaManager.shared.fetchLastImageLocalIdentifier(completion: { urlString in
                
                self.selectedImageIdentifier = urlString
                self.selectedImageUrl = nil
                self.ext = nil
                backBtnPressed()
            })
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        imagePicker.dismiss(animated: true, completion: nil)
        selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        UIImageWriteToSavedPhotosAlbum(selectedImage, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if type == PostType.image {
            return photoAssets.count
        } else {
            return videoAssets.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SHOW_CAMERA_CVC, for: indexPath) as! ShowCameraCVC
            return cell
            
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PHOTO_CVC, for: indexPath) as! PhotoCVC

            var asset: PHAsset!
            
            if type == PostType.image {
                
                asset = photoAssets[(indexPath as NSIndexPath).row]
                
                print("Fetching cached images...")
                MediaManager.shared.fetchCachedImage(asset: asset, Success: { photo in
                    
                    print("Fetched cached image.")
                    cell.configureCell(image: photo)
                    
                }, Failure: {
                    
                    print("Fetching image not in cache...")
                    MediaManager.shared.fetchImage(asset: asset, targetSize: self.targetSize, completion: { photo in
                        
                        cell.configureCell(image: photo)
                        print("Fetched image not in cache.")
                    })
                })
                return cell
                
            } else if type == PostType.video {
                
                asset = videoAssets[(indexPath as NSIndexPath).row]
                
                return cell
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return targetSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row != 0 {
            
            let asset = photoAssets[(indexPath as NSIndexPath).row]
            
            MediaManager.shared.fetchImage(asset: asset, completion: { (photo, url, ext) in
                
                self.selectedImage = photo
                self.selectedImageUrl = url
                self.ext = ext
                self.performSegue(withIdentifier: UNWIND_MEDIA_VC, sender: self)
            })
        } else {
            present(imagePicker, animated: true, completion: nil)
        }
    }

}
