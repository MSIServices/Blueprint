//
//  SignUpOneVC.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/11/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import UIKit

class SignUpOneVC: UIViewController, UITextFieldDelegate {

    @IBOutlet var mainV: MainV!
    @IBOutlet weak var emailField: CustomTF!
    @IBOutlet weak var nextBtnBttm: NSLayoutConstraint!
    
    let textFont = UIFont(name: "OpenSans-Regular", size: 20.0)!
    let placeholderFont = UIFont(name: "OpenSans-LightItalic", size: 20.0)!

    var errorAlert: SingleActionAlertV!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.configureBttmBorderType(textFont: textFont, textColor: UIColor.white, placeholder: "Email", placeholderColor: UIColor.lightText, placeholderFont: placeholderFont, borderColor: CHAIN_CREAM, borderThickness: 1.0, image: "email-cream", size: 30.0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        emailField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        nextBtnBttm.constant = 0
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == SIGN_UP_TWO_VC {
            
            let vC = segue.destination as! SignUpTwoVC
            vC.email = emailField.text!
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
    
    @IBAction func nextBtnPressed(_ sender: Any) {
        
        if let email = emailField.text, email != "" {
            
            if email.isValidEmail() {
                performSegue(withIdentifier: SIGN_UP_TWO_VC, sender: self)
            } else {
                errorAlert = mainV.showError(msg: "Email is not valid.", animated: true)
                errorAlert.confirmationBtn.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
            }
        } else {
            errorAlert = mainV.showError(msg: "Email cannot be empty.", animated: true)
            errorAlert.confirmationBtn.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        }
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND_MAIN_VC, sender: self)
    }
    
    @IBAction func unwindToSignUpOneVC(segue: UIStoryboardSegue) { }

}
