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
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        if #available(iOS 10.0, *) {
            
            let context = appDelegate.persistentContainer.viewContext
            context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            
            let messageEntity = NSEntityDescription.entity(forEntityName: "MessageCD", in: context)
            let newMessage: MessageCD = NSManagedObject(entity: messageEntity!, insertInto: context) as! MessageCD
            
            newMessage.messageId = message.messageId! as NSNumber
            newMessage.text = message.text
            newMessage.timestamp = message.timestamp! as NSDate
            newMessage.sender = sender
            newMessage.conversation = conversation
            
            do {
                try newMessage.managedObjectContext?.save()
                
                return newMessage
                
            } catch let err as NSError {
                print("ERROR SAVING: \(err.debugDescription)")
            }
        }
        return nil
    }
    
    static func save(message: Message, conversation: ConversationCD, sender: UserCD) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        if #available(iOS 10.0, *) {
            
            let context = appDelegate.persistentContainer.viewContext
            context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            
            let messageEntity = NSEntityDescription.entity(forEntityName: "MessageCD", in: context)
            let newMessage: MessageCD = NSManagedObject(entity: messageEntity!, insertInto: context) as! MessageCD
            
            newMessage.messageId = message.messageId! as NSNumber
            newMessage.text = message.text
            newMessage.timestamp = message.timestamp! as NSDate
            newMessage.conversation = conversation
            newMessage.sender = sender
            
            do {
                try newMessage.managedObjectContext?.save()
                print("Saved message...")
            } catch let err as NSError {
                print("ERROR SAVING: \(err.debugDescription)")
            }
        }
    }
    
    static func fetchAll() -> [MessageCD]? {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        if #available(iOS 10.0, *) {
            
            let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MessageCD")
            
            do {
                let messages = try context.fetch(request) as! [MessageCD]
                print("Fetched all...")
                
                return messages
                
            } catch let error as NSError {
                print("ERROR FETCHING ALL: \(error.debugDescription)")
            }
        }
        return nil
    }
    
}
