//
//  ImportantStuff.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 9/8/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//


/* KEYBOARD NOTIFICATIONS */

//NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

//func keyboardWillShow(_ notification: Notification) {
//    
//    if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//        
//        if view.frame.origin.y == 0 {
//            
//            self.nextBtnBttm.constant = keyboardSize.height
//            
//            UIView.animate(withDuration: 0.25) {
//                self.view.layoutIfNeeded()
//            }
//        }
//    }
//}
//
//func keyboardWillHide(_ notification: Notification) {
//    
//    self.nextBtnBttm.constant = 0
//    
//    UIView.animate(withDuration: 0.25) {
//        self.view.layoutIfNeeded()
//    }
//}
