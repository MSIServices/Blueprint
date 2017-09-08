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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    class func nib() -> MessageTVC {
        return UINib(nibName: self.nameOfClass, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MessageTVC
    }
    
    func configureCell() {
        
    }
    
}
