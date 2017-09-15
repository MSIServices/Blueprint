//
//  MessageTVC.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 9/7/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import UIKit

class MessageTVC: UITableViewCell {

    @IBOutlet weak var recipientView: UIView!
    @IBOutlet weak var senderView: UIView!
    @IBOutlet weak var recipientLbl: UILabel!
    @IBOutlet weak var senderLbl: UILabel!
    @IBOutlet weak var timestampLbl: UILabel!
    @IBOutlet weak var recipientNameLbl: UILabel!
    @IBOutlet weak var timestampLblHeight: NSLayoutConstraint!
    @IBOutlet weak var timestampLblTop: NSLayoutConstraint!
    
    var message: MessageCD!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        senderView.layer.cornerRadius = 3
        recipientView.layer.cornerRadius = 3
    }
    
    class func nib() -> UINib {
        return UINib(nibName: self.nameOfClass, bundle: nil)
    }
    
    func configureCell(message: MessageCD, showDate: Bool) {
        
        self.message = message
        dump(message)
        
        if showDate {
            
            timestampLblTop.constant = 4
            timestampLblHeight.constant = 15
            timestampLbl.text = message.timestamp?.formatDateFrom(outputFormat: "MMM d, h:mm a")
        } else {
            
            timestampLblTop.constant = 0
            timestampLblHeight.constant = 0
        }
        
        if message.sender?.username == UserDefaults.standard.value(forKey: USERNAME) as? String {
            
            recipientLbl.setContentHuggingPriority(250, for: UILayoutConstraintAxis.vertical)
            senderLbl.setContentHuggingPriority(750, for: UILayoutConstraintAxis.vertical)
            senderLbl.text = message.text
            senderLbl.sizeToFit()
            recipientNameLbl.isHidden = true
            recipientView.isHidden = true
            senderView.isHidden = false
            
        } else {
            
            senderLbl.setContentHuggingPriority(250, for: UILayoutConstraintAxis.vertical)
            recipientLbl.setContentHuggingPriority(750, for: UILayoutConstraintAxis.vertical)
            recipientLbl.text = message.text
            recipientNameLbl.text = message.sender?.username?.capitalized
            recipientLbl.sizeToFit()
            recipientNameLbl.isHidden = false
            recipientView.isHidden = false
            senderView.isHidden = true
        }
        self.layoutIfNeeded()
    }
    
}
