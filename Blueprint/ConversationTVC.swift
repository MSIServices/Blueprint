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
    
    var conversation: ConversationCD!
    var lastMessage: MessageCD!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    class func nib() -> UINib {
        return UINib(nibName: self.nameOfClass, bundle: nil)
    }
    
    func configureCell(conversation: ConversationCD) {
        
        self.conversation = conversation
        
        let messages: [MessageCD] = Array(conversation!.messages!) as! [MessageCD]
        let sortedMessages = messages.sorted {$0.timestamp.compare($1.timestamp as Date) == .orderedAscending}
        lastMessage = sortedMessages.last
        
        setConversationImage()
        setParticipants()
        setLastMessage()
        setTimeStamp()
    }
    
    func setConversationImage() {
        
        if (conversation.participants?.count)! > 1 {
            conversationImageView.image = UIImage(named: "group-red")
        } else {
            
        }
    }
    
    func setTimeStamp() {
        timestampLbl.text = lastMessage.timestamp
    }
    
    func setLastMessage() {
        lastMessageLbl.text = lastMessage.text
    }
    
    func setParticipants() {
        
        let participants: [UserCD] = Array(conversation.participants) as! [UserCD]
        
        for (i,p) in participants.enumerated() {
            
            if p.userId == User.currentId { continue }
            
            if i != participants.count - 1 {
                participantsLbl.text += "\(p.username?.capitalized), "
            } else {
                participantsLbl.text += "\(p.username?.capitalized)"
            }
        }
    }
    
}
