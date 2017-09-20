//
//  CustomTF.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/12/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import UIKit

class CustomTF: UITextField {

    var textPaddingAdjustment: CGFloat = 0.0
    var placeholderYPadding: CGFloat = 0.0
    var textYPadding: CGFloat = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        autocorrectionType = .no
    }

    override func deleteBackward() {
        super.deleteBackward()
        
        NotificationCenter.default.post(name: Notifications.customNotification.BackspaceDetected, object: nil)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: textPaddingAdjustment, y: textYPadding, width: bounds.size.width, height: bounds.size.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: textPaddingAdjustment, y: textYPadding, width: bounds.size.width - textPaddingAdjustment + 10, height: bounds.size.height)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: textPaddingAdjustment, y: placeholderYPadding, width: bounds.size.width, height: bounds.size.height)
    }
    
    func setLeftIcon(image: String, size: CGFloat, iconPadding: CGFloat, textPadding: CGFloat, borderColor: UIColor?, borderWidth: CGFloat?) {
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        imageView.image = UIImage(named: image)
        let view = UIView(frame: CGRect(x: 0, y: 0, width: size + 20, height: self.bounds.size.height))
        view.layer.borderColor = borderColor?.cgColor
        view.layer.cornerRadius = 3.0
        
        if let width = borderWidth {
            view.layer.borderWidth = width
        } else if borderColor != nil {
            view.layer.borderWidth = 1.0
        }
        
        imageView.center = view.center
        
        view.addSubview(imageView)
        
        leftView = view
        leftViewMode = UITextFieldViewMode.always
        
        if textAlignment == .left {
            textPaddingAdjustment = size + iconPadding + textPadding
        }
    }
    
    func configureBttmBorderType(textFont: UIFont, textColor: UIColor, placeholder: String, placeholderColor: UIColor, placeholderFont: UIFont, borderColor: UIColor, borderThickness: CGFloat, image: String, size: CGFloat) {
        
        backgroundColor = UIColor.clear
        autocorrectionType = .no
        borderStyle = .none
        
        self.font = textFont
        self.textColor = textColor
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        imageView.image = UIImage(named: image)
        let view = UIView(frame: CGRect(x: 0, y: 0, width: size + 10, height: self.bounds.size.height))
        imageView.center = view.center
        view.addSubview(imageView)
        
        leftView = view
        leftViewMode = UITextFieldViewMode.always
        
        if textAlignment == .left || textAlignment == .natural {
            textPaddingAdjustment = size + 20.0
        }
        
        addBorder(side: .south, thickness: borderThickness, color: borderColor, borderAdjustment: 0.0)
        
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedStringKey.foregroundColor: placeholderColor, NSAttributedStringKey.font: placeholderFont])
    }

}
