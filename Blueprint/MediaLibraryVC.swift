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

class MediaLibraryVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet var mainV: MainV!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let layout = UICollectionViewFlowLayout()
    
    var settingsAlertV: DoubleActionAlertV!
    var photoAssets = [PHAsset]()
    var fetchGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoAssets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SHOW_CAMERA_CVC, for: indexPath) as! ShowCameraCVC
            return cell
            
        } else {
            
            let asset = photoAssets[(indexPath as NSIndexPath).row]
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PHOTO_CVC, for: indexPath) as! PhotoCVC
                
            print("Fetching cached images...")
            MediaManager.shared.fetchCachedImage(asset: asset, Success: { photo in
                    
                print("Fetched cached image.")
                cell.configureCell(image: photo)
                    
            }, Failure: {
                    
                print("Fetching image not in cache...")
                MediaManager.shared.fetchImage(asset: asset, completion: { photo in
                    cell.configureCell(image: photo)
                    print("Fetched image not in cache.")
                })
            })
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.size.width / 3) - 8, height: (UIScreen.main.bounds.size.width / 3) - 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row != 0 {
            
            let cell = collectionView.cellForItem(indexPath: indexPath) as! PhotoCVC
            
        }
    }

}
