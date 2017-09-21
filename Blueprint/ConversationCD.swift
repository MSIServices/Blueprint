//
//  ConversationCD+CoreDataClass.swift
//  
//
//  Created by Stephen Muscarella on 9/7/17.
//
//

import Foundation
import CoreData

fileprivate let ClassEntity = "ConversationCD"

(ConversationCD)
public class ConversationCD: NSManagedObject {

    static func sync(conversation: Conversation) -> ConversationCD? {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        if #available(iOS 10.0, *) {
            
            let context = appDelegate.persistentContainer.viewContext
            context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            
            var newConvo: ConversationCD!
            
            if let existingConversation = ConversationCD.fetchById(conversationId: conversation.conversationId!) {
                newConvo = existingConversation
            } else {
                
                let conversationEntity = NSEntityDescription.entity(forEntityName: ClassEntity, in: context)
                newConvo = NSManagedObject(entity: conversationEntity!, insertInto: context) as! ConversationCD
                newConvo.conversationId = conversation.conversationId as NSNumber?
                newConvo.startDate = conversation.startDate as NSDate?
            }
            newConvo.updatedAt = NSDate()
            
            for user in conversation.participants {

                var participant: UserCD!
                
                if let existingUser = UserCD.fetchById(UserId: user.userId!) {
                    participant = existingUser
                } else {
                    
                    let userEntity = NSEntityDescription.entity(forEntityName: "UserCD", in: context)
                    let newUser: UserCD = NSManagedObject(entity: userEntity!, insertInto: context) as! UserCD
                    
                    if let userId = user.userId {
                        newUser.userId = userId
                    }
                    if let email = user.email {
                        newUser.email = email
                    }
                    if let username = user.username {
                        newUser.username = username
                    }
                    if let avatar = user.avatar {
                        newUser.avatar = avatar
                    }
                    participant = newUser
                }
                newConvo.addToParticipants(participant)
            }
            
            for msg in conversation.messages {
                
                let messageEntity = NSEntityDescription.entity(forEntityName: "MessageCD", in: context)
                let newMessage: MessageCD = NSManagedObject(entity: messageEntity!, insertInto: context) as! MessageCD
                
                newMessage.messageId = msg.messageId
                newMessage.text = msg.text
                newMessage.timestamp = msg.timestamp as NSDate?
                newMessage.conversation = newConvo
                
                var sender: UserCD!
                
                if let existingUser: UserCD = UserCD.fetchById(UserId: (msg.sender?.userId)!) {
                    sender = existingUser
                } else {
                    
                    let userEntity = NSEntityDescription.entity(forEntityName: "UserCD", in: context)
                    let newUser: UserCD = NSManagedObject(entity: userEntity!, insertInto: context) as! UserCD
                    
                    if let userId = msg.sender?.userId {
                        newUser.userId = userId
                    }
                    if let email = msg.sender?.email {
                        newUser.email = email
                    }
                    if let username = msg.sender?.username {
                        newUser.username = username
                    }
                    if let avatar = msg.sender?.avatar {
                        newUser.avatar = avatar
                    }
                    sender = newUser
                }
                newMessage.sender = sender
                newConvo.addToMessages(newMessage)
            }
            
            do {
                try newConvo.managedObjectContext?.save()
                print("Saved Conversation...")
                
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: ClassEntity)
                request.sortDescriptors = [NSSortDescriptor(key: "updatedAt", ascending: false)]
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
    
    static func fetch(conversationId: NSNumber) -> ConversationCD? {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        if #available(iOS 10.0, *) {
            
            let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: ClassEntity)
            request.predicate = NSPredicate(format: "conversationId == %@", conversationId)
            
            do {
                let conversation = try context.fetch(request).first as! ConversationCD
                
                return conversation
                
            } catch let error as NSError {
                print("Failed to fetch user: \(error.debugDescription)")
            }
        }
        return nil
    }
    
    static func fetchById(conversationId: NSNumber) -> ConversationCD? {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        if #available(iOS 10.0, *) {
            
            let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserCD")
            request.predicate = NSPredicate(format: "userId == %@", conversationId)
            request.fetchLimit = 1
            
            do {
                let convo = try context.fetch(request).first as? ConversationCD
                print("Fetched...")
                
                return convo
                
            } catch let error as NSError {
                print("ERROR FETCHING: \(error.debugDescription)")
            }
        }
        return nil
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
                print("Fetched all conversations...")
                
                return conversations
                
            } catch let error as NSError {
                print("ERROR FETCHING ALL: \(error.debugDescription)")
            }
        }
        return nil
    }

}
