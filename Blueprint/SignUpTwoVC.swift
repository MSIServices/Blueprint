//
//  SignUpTwoVC.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/12/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import UIKit

class SignUpTwoVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameField: CustomTF!
    @IBOutlet weak var nextBtnBttm: NSLayoutConstraint!
    @IBOutlet var mainV: MainV!
    
    let textFont = UIFont(name: "OpenSans-Regular", size: 20.0)!
    let placeholderFont = UIFont(name: "OpenSans-LightItalic", size: 20.0)!

    var errorAlert: SingleActionAlertV!
    var email: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameField.configureBttmBorderType(textFont: textFont, textColor: UIColor.white, placeholder: "Username", placeholderColor: UIColor.lightText, placeholderFont: placeholderFont, borderColor: CHAIN_CREAM, borderThickness: 1.0, image: "user-cream", size: 30.0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        usernameField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        nextBtnBttm.constant = 0
        view.endEditing(true)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if usernameField.text == "" {
            errorAlert = mainV.showError(msg: "Username is empty.", animated: true)
            errorAlert.confirmationBtn.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
            return false
        } else if (usernameField.text?.characters.count)! < 6 {
            errorAlert = mainV.showError(msg: "Username must be at least 6 characters.", animated: true)
            errorAlert.confirmationBtn.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
            return false
        } else if (usernameField.text?.characters.count)! > 20 {
            errorAlert = mainV.showError(msg: "Username must be no more than 20 characters.", animated: true)
            errorAlert.confirmationBtn.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
            return false
        } else if usernameField.text?.isAlphaNumeric() == false {
            errorAlert = mainV.showError(msg: "Username must contain alphanumerica characters only.", animated: true)
            errorAlert.confirmationBtn.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == SIGN_UP_THREE_VC {
            
            let vC = segue.destination as! SignUpThreeVC
            vC.email = email
            vC.username = usernameField.text!
        }
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
    
     func dismissAlert() {
        mainV.removeAlert()
    }
            
    @IBAction func backBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND_SIGN_UP_ONE_VC, sender: self)
    }

    @IBAction func unwindToSignUpTwoVC(segue: UIStoryboardSegue) { }

}
