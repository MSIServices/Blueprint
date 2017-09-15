//
//  ConversationCD+CoreDataClass.swift
//  
//
//  Created by Stephen Muscarella on 9/7/17.
//
//

import Foundation
import CoreData

@objc(ConversationCD)
public class ConversationCD: NSManagedObject {

    static func sync(conversation: Conversation) -> ConversationCD? {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        if #available(iOS 10.0, *) {
            
            let context = appDelegate.persistentContainer.viewContext
            context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
            
            let conversationEntity = NSEntityDescription.entity(forEntityName: "ConversationCD", in: context)
            let newConvo: ConversationCD = NSManagedObject(entity: conversationEntity!, insertInto: context) as! ConversationCD
            
            newConvo.conversationId = conversation.conversationId as NSNumber
            newConvo.startDate = conversation.startDate as NSDate
            
            for user in conversation.participants {
                
                let userEntity = NSEntityDescription.entity(forEntityName: "UserCD", in: context)
                let newUser: UserCD = NSManagedObject(entity: userEntity!, insertInto: context) as! UserCD

                newUser.userId = user.userId as NSNumber
                newUser.email = user.email
                newUser.username = user.username
                newUser.avatar = user.avatar
                
                newConvo.addToParticipants(newUser)
            }
                        
            for msg in conversation.messages {
                
                let userEntity = NSEntityDescription.entity(forEntityName: "UserCD", in: context)
                let newUser: UserCD = NSManagedObject(entity: userEntity!, insertInto: context) as! UserCD
                
                newUser.userId = msg.sender.userId as NSNumber
                newUser.email = msg.sender.email
                newUser.username = msg.sender.username
                newUser.avatar = msg.sender.avatar
                
                let messageEntity = NSEntityDescription.entity(forEntityName: "MessageCD", in: context)
                let newMessage: MessageCD = NSManagedObject(entity: messageEntity!, insertInto: context) as! MessageCD
                
                newMessage.messageId = msg.messageId as NSNumber
                newMessage.text = msg.text
                newMessage.timestamp = msg.timestamp as NSDate
                newMessage.sender = newUser
                newMessage.conversation = newConvo
                
                newConvo.addToMessages(newMessage)
            }
            
            do {
                try newConvo.managedObjectContext?.save()
                print("Saved Conversation...")
                
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ConversationCD")
                request.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: false)]
                request.fetchLimit = 1

                do {
                    let conversation = try context.fetch(request) as! [ConversationCD]
                    
                    return conversation.first
                    
                } catch {
                    print("ERROR FETCHING RECENTLY SAVED CONVERSATION: \(error.localizedDescription)")
                }
            } catch {
                print("ERROR SAVING CONVERSATION: \(error.localizedDescription)")
            }
        }
        return nil
    }
    
    static func fetchFromParticipants(participants: [UserCD]) -> ConversationCD? {
        
        var convos = [ConversationCD]()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return convos.first
        }
        
        if #available(iOS 10.0, *) {
            
            let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ConversationCD")
            request.predicate = NSPredicate(format: "ANY participants IN %@", participants)
            
            do {
                convos = try context.fetch(request) as! [ConversationCD]
            } catch let error as NSError {
                print("Failed to fetch user: \(error.debugDescription)")
            }
        }
        return convos.first
    }
    
    static func fetchAll() -> [ConversationCD]? {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
    
        if #available(iOS 10.0, *) {
    
            let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ConversationCD")
    
            do {
                let conversations = try context.fetch(request) as! [ConversationCD]
                print("Fetched all...")
                
                return conversations
                
            } catch let error as NSError {
                print("ERROR FETCHING ALL: \(error.debugDescription)")
            }
        }
        return nil
    }

}
