//
//  TextVC.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/18/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import UIKit

fileprivate let placeholderText = "Text"

class TextVC: UIViewController, UITextViewDelegate {

    @IBOutlet var mainV: MainV!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var nextBtnBttm: NSLayoutConstraint!
    
    var errorAlert: SingleActionAlertV!
    var audioUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addBarButton(imageNormal: "back-white", imageHighlighted: nil, action: #selector(backBtnPressed), side: .west)
        applyPlaceholderStyle(aTextview: textView, placeholderText: placeholderText)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textView.becomeFirstResponder()
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == RECIPIENT_VC {
            
            if textView.text == placeholderText && audioUrl == nil  {
                errorAlert = mainV.showError(msg: "Text cannot be empty.", animated: true)
                errorAlert.confirmationBtn.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
                return false
            }
            return true
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == RECIPIENT_VC {
            
            let vC = segue.destination as! RecipientVC
            
            if audioUrl != nil {
                vC.type = PostType.audio
                vC.audioUrl = audioUrl!
            } else {
                vC.type = PostType.text
            }
            
            if let txt = textView.text, txt != placeholderText {
                vC.text = txt
            }
            vC.previousVC = nameOfClass
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        textView.becomeFirstResponder()
    }
    
    func applyPlaceholderStyle(aTextview: UITextView, placeholderText: String) {

        aTextview.textColor = UIColor.gray
        aTextview.text = placeholderText
        aTextview.textAlignment = .center
        aTextview.font = UIFont(name: "OpenSans-LightItalic", size: 16)!
    }
    
    func applyNonPlaceholderStyle(aTextview: UITextView) {

        aTextview.textColor = UIColor.darkText
        aTextview.alpha = 1.0
        aTextview.textAlignment = .left
        aTextview.font = UIFont(name: "OpenSans-Regular", size: 16)!
    }
    
    func textViewShouldBeginEditing(_ aTextView: UITextView) -> Bool {
        
        if aTextView.text == placeholderText {
            moveCursorToStart(aTextView: aTextView)
        }
        return true
    }
    
    func moveCursorToStart(aTextView: UITextView) {
        
        DispatchQueue.main.async {
            aTextView.selectedRange = NSMakeRange(0, 0);
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if(text == "\n") {
            
            textView.resignFirstResponder()
            self.nextBtnBttm.constant = 0
            return false
        }
        
        let newLength = textView.text.utf16.count + text.utf16.count - range.length
        
        if newLength > 0 {
            
            if textView.text == placeholderText {
                
                if text.utf16.count == 0 {
                    return false
                }
                applyNonPlaceholderStyle(aTextview: textView)
                textView.text = ""
            }
            return true
            
        } else {
            
            applyPlaceholderStyle(aTextview: textView, placeholderText: placeholderText)
            moveCursorToStart(aTextView: textView)
            return false
        }
    }
    
    func keyboardWillShow(_ notification: Notification) {
        
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            if view.frame.origin.y == 0 {
                
                self.nextBtnBttm.constant = keyboardSize.height - 50
                
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
    
    func backBtnPressed() {
        performSegue(withIdentifier: UNWIND_NEW_POST_VC, sender: self)
    }
    
    @IBAction func unwindToTextVC(segue: UIStoryboardSegue) { }

}
