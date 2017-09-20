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
    
    override func layoutSubviews() {
//        super.layoutSubviews()
        
        contentView.addViewBackedBorder(side: .south, thickness: 1.0, color: UIColor.lightGray)
    }
    
    class func nib() -> UINib {
        return UINib(nibName: self.nameOfClass, bundle: nil)
    }
    
    func configureCell(conversation: ConversationCD) {
        
        self.conversation = conversation
        
        let messages: [MessageCD] = Array(conversation.messages!) as! [MessageCD]
        let sortedMessages = messages.sorted {$0.timestamp?.compare($1.timestamp! as Date) == .orderedAscending}
        lastMessage = sortedMessages.last
        
        setConversationImage()
        setLastMessage()
        setTimeStamp()
        setParticipants()
    }
    
    func setConversationImage() {
        
        if (conversation.participants?.count)! > 2 {
            conversationImageView.image = UIImage(named: "group-red")
        } else {
            conversationImageView.image = UIImage(named: "user")
        }
    }
    
    func setTimeStamp() {
        timestampLbl.text = lastMessage.timestamp?.formatDateFrom(outputFormat: "MMM d, h:mm a")
    }
    
    func setLastMessage() {
        lastMessageLbl.text = lastMessage.text
    }
    
    func setParticipants() {
        
        participantsLbl.text = ""
        
        var participants: [UserCD] = Array(conversation.participants!) as! [UserCD]
        participants.remove(at: participants.index {$0.username! == User.username}!)
        participants.sort { $0.username! < $1.username! }
        
        for (i,p) in participants.enumerated() {
            
            if i != participants.count - 1 {
                participantsLbl.text = participantsLbl.text! + "\(p.username!.capitalized), "
            } else {
                participantsLbl.text = participantsLbl.text! + "\(p.username!.capitalized)"
            }
        }
    }
    
}
