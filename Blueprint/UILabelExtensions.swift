//
//  UILabelExtensions.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 7/29/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    func addIcon(imageName: String, afterLabel: Bool = false) {
        
        let attachment: NSTextAttachment = NSTextAttachment()
        attachment.image = UIImage(named: imageName)
        attachment.bounds = CGRect(x: 0, y: -6, width: 20, height: 20)
        let attachmentString: NSAttributedString = NSAttributedString(attachment: attachment)
        
        if afterLabel {
            
            let strLabelText: NSMutableAttributedString = NSMutableAttributedString(string: self.text!)
            strLabelText.append(attachmentString)
            self.attributedText = strLabelText
            
        } else {
            
            let strLabelText: NSAttributedString = NSAttributedString(string: self.text!)
            let mutableAttachmentString: NSMutableAttributedString = NSMutableAttributedString(attributedString: attachmentString)
            mutableAttachmentString.append(strLabelText)
            self.attributedText = mutableAttachmentString
        }
    }
    
    func removeIcon() {
        let text = self.text
        self.attributedText = nil
        self.text = text
    }
    
    func heightToFit(label: UILabel) -> CGFloat {
        
        let maxHeight : CGFloat = 10000
        let labelSize = CGSize(width: label.frame.size.width, height: maxHeight)
        self.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        let rect = self.attributedText?.boundingRect(with: labelSize, options: .usesLineFragmentOrigin, context: nil)
        
        return rect!.size.height
    }
    
}
