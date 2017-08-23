//
//  TextFieldTVC.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/22/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import UIKit

class TextFieldTVC: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var textField: CustomTF!
    
    var messageDelegate: MessageDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textField.delegate = self
        textField.tag = 1
        textField.textPaddingAdjustment = 8
        textField.attributedPlaceholder = NSAttributedString(string: "Url", attributes: [NSFontAttributeName: UIFont(name: "OpenSans-LightItalic", size: 16)!, NSForegroundColorAttributeName: UIColor.gray])
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }
    
    class func nib() -> UINib {
        return UINib(nibName: "TextFieldTVC", bundle: nil)
    }
    
    func configureCell(text: String?) {
        textField.text = text
    }
    
    func textFieldDidChange() {
        messageDelegate.updateUrl!(text: textField.text)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == "\n" {
            textField.resignFirstResponder()
            return false
        }
        return true
    }

}
