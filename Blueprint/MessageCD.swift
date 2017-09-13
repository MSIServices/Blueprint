//
//  MessageCD+CoreDataClass.swift
//  
//
//  Created by Stephen Muscarella on 9/7/17.
//
//

import Foundation
import CoreData

@objc(MessageCD)
public class MessageCD: NSManagedObject {

    static func sync(message: Message, conversation: ConversationCD, sender: UserCD) -> MessageCD? {
        
        var savedMessage: MessageCD?
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return savedMessage
        }
        
        if #available(iOS 10.0, *) {
            
            let context = appDelegate.persistentContainer.viewContext
            context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
            
            let messageEntity = NSEntityDescription.entity(forEntityName: "MessageCD", in: context)
            let newMessage: MessageCD = NSManagedObject(entity: messageEntity!, insertInto: context) as! MessageCD
            
            newMessage.messageId = message.messageId as NSNumber
            newMessage.text = message.text
            newMessage.timestamp = message.timestamp as NSDate
            newMessage.sender = sender
            newMessage.conversation = conversation
            
            do {
                try newMessage.managedObjectContext?.save()
                savedMessage = newMessage
                print("Saved user...")
            } catch let err as NSError {
                print("ERROR SAVING: \(err.debugDescription)")
            }
        }
        return savedMessage
    }
    
}
