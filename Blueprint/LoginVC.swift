//
//  LoginVC.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/16/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet var mainV: MainV!
    @IBOutlet weak var emailField: CustomTF!
    @IBOutlet weak var passwordField: CustomTF!
    @IBOutlet weak var loginBtn: UIButton!
    
    let textFont = UIFont(name: "OpenSans-Regular", size: 20.0)!
    let placeholderFont = UIFont(name: "OpenSans-LightItalic", size: 20.0)!
    
    var errorAlert: SingleActionAlertV!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.configureBttmBorderType(textFont: textFont, textColor: UIColor.white, placeholder: "Email", placeholderColor: UIColor.lightText, placeholderFont: placeholderFont, borderColor: CHAIN_CREAM, borderThickness: 1.0, image: "email-cream", size: 30.0)
        
        passwordField.configureBttmBorderType(textFont: textFont, textColor: UIColor.white, placeholder: "Password", placeholderColor: UIColor.lightText, placeholderFont: placeholderFont, borderColor: CHAIN_CREAM, borderThickness: 1.0, image: "lock-outline-cream", size: 30.0)
        
        emailField.text = "a@a.com"
        passwordField.text = "12341234"
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
     func dismissAlert() {
        mainV.removeAlert()
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND_MAIN_VC, sender: self)
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        
        if let email = emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines), email != "", let password = passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines), password != "" {
            
            APIManager.shared.authenticate(email: email, password: password, Success: { user in
                
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
    }

}
