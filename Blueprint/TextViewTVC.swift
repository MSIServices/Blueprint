//
//  TextViewTVC.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/22/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import UIKit

fileprivate let placeholderText = "Text"

class TextViewTVC: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    
    var messageDelegate: MessageDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        textView.delegate = self
        textView.tag = 2
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        applyPlaceholderStyle(aTextview: textView, placeholderText: placeholderText)
    }
    
    class func nib() -> UINib {
        return UINib(nibName: self.nameOfClass, bundle: nil)
    }
    
    func configureCell(text: String?) {
        textView.text = text
    }
    
    func applyPlaceholderStyle(aTextview: UITextView, placeholderText: String) {
        
        aTextview.textColor = UIColor.gray
        aTextview.text = placeholderText
        aTextview.textAlignment = .left
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
    
    func textViewDidChange(_ textView: UITextView) {
        messageDelegate.updateText!(text: textView.text)
    }

}
