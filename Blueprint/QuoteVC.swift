//
//  QuoteVC.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/18/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import UIKit

fileprivate let placeholderText = "Text"

class QuoteVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var quoteImageView: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var nextBtnBttm: NSLayoutConstraint!
    
    var selectedImageIdentifier: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        applyPlaceholderStyle(aTextview: textView, placeholderText: placeholderText)
        addBarButton(imageNormal: "back-white", imageHighlighted: nil, action: #selector(backBtnPressed), side: .west)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == MEDIA_LIBRARY_VC {
            
            let vC = segue.destination as! MediaLibraryVC
            vC.type = PostType.image
            vC.previousVC = QUOTE_VC
        }
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
            aTextView.selectedRange = NSMakeRange(0, 0)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.text != "" {
            quoteImageView.image = UIImage(named: "no-preview")
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
    
    func backBtnPressed() {
        performSegue(withIdentifier: UNWIND_NEW_POST_VC, sender: self)
    }
    
    @IBAction func pickQuoteBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: MEDIA_LIBRARY_VC, sender: self)
    }
    
    @IBAction func unwindToQuoteVC(segue: UIStoryboardSegue) { }
    
}
