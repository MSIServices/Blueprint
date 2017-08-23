//
//  SignUpThreeVC.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/12/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import UIKit
import CryptoSwift

class SignUpThreeVC: UIViewController, UITextFieldDelegate {

    @IBOutlet var mainV: MainV!
    @IBOutlet weak var passwordField: CustomTF!
    @IBOutlet weak var passwordConfirmationField: CustomTF!
    @IBOutlet weak var nextBtnBttm: NSLayoutConstraint!
    
    let textFont = UIFont(name: "OpenSans-Regular", size: 20.0)!
    let placeholderFont = UIFont(name: "OpenSans-LightItalic", size: 20.0)!
    
    var errorAlert: SingleActionAlertV!
    
    var email: String!
    var username: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordField.configureBttmBorderType(textFont: textFont, textColor: UIColor.white, placeholder: "Password", placeholderColor: UIColor.lightText, placeholderFont: placeholderFont, borderColor: CHAIN_CREAM, borderThickness: 1.0, image: "lock-fill-cream", size: 30.0)
        
        passwordConfirmationField.configureBttmBorderType(textFont: textFont, textColor: UIColor.white, placeholder: "Password Confirmation", placeholderColor: UIColor.lightText, placeholderFont: placeholderFont, borderColor: CHAIN_CREAM, borderThickness: 1.0, image: "lock-outline-cream", size: 30.0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        passwordField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        nextBtnBttm.constant = 0
        view.endEditing(true)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if passwordField.text == "" {
            errorAlert = mainV.showError(msg: "Password is empty.", animated: true)
            errorAlert.confirmationBtn.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
            return false
        } else if (passwordField.text?.characters.count)! < 6 {
            errorAlert = mainV.showError(msg: "Password must be at least 6 characters.", animated: true)
            errorAlert.confirmationBtn.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
            return false
        } else if (passwordField.text?.characters.count)! > 30 {
            errorAlert = mainV.showError(msg: "Password Confirmation must be no more than 30 characters.", animated: true)
            errorAlert.confirmationBtn.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
            return false
        } else if passwordField.text != passwordConfirmationField.text {
            errorAlert = mainV.showError(msg: "Password fields do not match.", animated: true)
            errorAlert.confirmationBtn.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == SIGN_UP_FOUR_VC {
            
            let vC = segue.destination as! SignUpFourVC
            
            vC.email = email
            vC.username = username
            vC.password = passwordField.text!
        }
    }
    
    func dismissAlert() {
        mainV.removeAlert()
    }
    
    func keyboardWillShow(_ notification: Notification) {
        
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            if view.frame.origin.y == 0 {
                
                self.nextBtnBttm.constant = keyboardSize.height
                
                UIView.animate(withDuration: 0.25) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        
        self.nextBtnBttm.constant = 0
                
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND_SIGN_UP_TWO_VC, sender: self)
    }
    
    @IBAction func unwindToSignUpThreeVC(segue: UIStoryboardSegue) { }

}
