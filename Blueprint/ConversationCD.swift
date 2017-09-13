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

    static func save(conversation: Conversation) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        if #available(iOS 10.0, *) {
            
            let context = appDelegate.persistentContainer.viewContext
            context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
            
            let conversationEntity = NSEntityDescription.entity(forEntityName: "ConversationCD", in: context)
            let newConvo: ConversationCD = NSManagedObject(entity: conversationEntity!, insertInto: context) as! ConversationCD
            
            newConvo.conversationId = conversation.conversationId as NSNumber
            newConvo.startDate = conversation.startDate as NSDate
            
            for user in conversation.participants {
                
                if let savedUser = UserCD.sync(user: user) {
                    newConvo.addToParticipants(savedUser)
                }
            }
            for msg in conversation.messages {
                
                if let savedMessage = MessageCD.sync(message: msg, conversation: newConvo, sender: UserCD.sync(user: msg.sender)!) {
                    newConvo.addToMessages(savedMessage)
                }
            }

            do {
                try newConvo.managedObjectContext?.save()
                print("Saved Conversation...")
            } catch {
                print("ERROR SAVING CONVERSATION: \(error.localizedDescription)")
            }
        }
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

}
