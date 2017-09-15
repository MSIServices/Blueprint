//
//  ConversationCD+CoreDataProperties.swift
//  
//
//  Created by Stephen Muscarella on 9/7/17.
//
//

import Foundation
import CoreData

extension ConversationCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ConversationCD> {
        return NSFetchRequest<ConversationCD>(entityName: "ConversationCD")
    }

    @NSManaged public var conversationId: NSNumber?
    @NSManaged public var startDate: NSDate?
    @NSManaged public var updatedAt: NSDate?
    @NSManaged public var participants: NSSet?
    @NSManaged public var messages: NSSet?

}

// MARK: Generated accessors for participants
extension ConversationCD {

    @objc(addParticipantsObject:)
    @NSManaged public func addToParticipants(_ value: UserCD)
    
    @objc(removeParticipantsObject:)
    @NSManaged public func removeFromParticipants(_ value: UserCD)

    @objc(addParticipants:)
    @NSManaged public func addToParticipants(_ values: NSSet)

    @objc(removeParticipants:)
    @NSManaged public func removeFromParticipants(_ values: NSSet)

}

// MARK: Generated accessors for messages
extension ConversationCD {

    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: MessageCD)

    @objc(removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: MessageCD)

    @objc(addMessages:)
    @NSManaged public func addToMessages(_ values: NSSet)

    @objc(removeMessages:)
    @NSManaged public func removeFromMessages(_ values: NSSet)

}
