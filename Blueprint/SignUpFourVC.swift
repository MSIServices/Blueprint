//
//  SignUpFourVC.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/12/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import UIKit
import CryptoSwift
import Alamofire

class SignUpFourVC: UIViewController, UINavigationControllerDelegate, UITextViewDelegate, UIImagePickerControllerDelegate {
    
    open class MyServerTrustPolicyManager: ServerTrustPolicyManager {
        open override func serverTrustPolicy(forHost host: String) -> ServerTrustPolicy? {
            return ServerTrustPolicy.disableEvaluation
        }
    }

    @IBOutlet var mainV: MainV!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoBtn: UIButton!
    @IBOutlet weak var nextBtnBttm: NSLayoutConstraint!
    
    let imagePicker = UIImagePickerController()
    
    var errorAlert: SingleActionAlertV!
    var email: String!
    var username: String!
    var password: String!
    var avatar: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print(try! encryptedPassword.aesDecrypt(key: AES_KEY, iv: passwordIv))
        
        imagePicker.delegate = self

        photoImageView.layer.cornerRadius = photoImageView.frame.size.height / 2
        photoBtn.layer.cornerRadius = photoBtn.frame.size.width / 2
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == HOME_VC {
            
//            let vC = segue.destination as! HomeVC
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        
        dismiss(animated: true, completion: nil)
        
        if mediaType.isEqual(to: "public.image") {
            
            if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                
                photoImageView.contentMode = .scaleAspectFill
                photoImageView.image = pickedImage
                photoImageView.clipsToBounds = true
                photoImageView.layer.borderColor = UIColor.white.cgColor
                photoImageView.layer.borderWidth = 1.0
            }
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            if view.frame.origin.y == 0 {
                
                self.nextBtnBttm.constant = keyboardSize.height
                
                UIView.animate(withDuration: 0.25) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        
        self.nextBtnBttm.constant = 0
                
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func dismissAlert() {
        mainV.removeAlert()
    }

    @IBAction func photoBtnPressed(_ sender: Any) {
        
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.mediaTypes = ["public.image"]
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func finishBtnPressed(_ sender: Any) {
        
        APIManager.shared.createUser(email: email, username: username, password: password, avatar: avatar, Success: { user in
        
            UserDefaults.standard.set(user.userId, forKey: USER_ID)
            UserDefaults.standard.set(user.email, forKey: EMAIL)
            UserDefaults.standard.set(user.username, forKey: USERNAME)

            self.performSegue(withIdentifier: HOME_VC, sender: self)
            
        }, Failure: { error in
            
            if let msg = error {
                self.errorAlert = self.mainV.showError(msg: msg, animated: true)
                self.errorAlert.confirmationBtn.addTarget(self, action: #selector(self.dismissAlert), for: .touchUpInside)
            }
        })
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND_SIGN_UP_THREE_VC, sender: self)
    }
    
}
