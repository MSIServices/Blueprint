//
//  ConversationTVC.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 9/7/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import UIKit

class ConversationTVC: UITableViewCell {

    @IBOutlet weak var conversationImageView: UIImageView!
    @IBOutlet weak var participantsLbl: UILabel!
    @IBOutlet weak var lastMessageLbl: UILabel!
    @IBOutlet weak var timestampLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    class func nib() -> UINib {
        return UINib(nibName: self.nameOfClass, bundle: nil)
    }
    
    func configureCell(conversation: ConversationCD) {
        
        
    }
    
}
