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

    (addParticipantsObject:)
    @NSManaged public func addToParticipants(_ value: UserCD)
    
    (removeParticipantsObject:)
    @NSManaged public func removeFromParticipants(_ value: UserCD)

    (addParticipants:)
    @NSManaged public func addToParticipants(_ values: NSSet)

    (removeParticipants:)
    @NSManaged public func removeFromParticipants(_ values: NSSet)

}

// MARK: Generated accessors for messages
extension ConversationCD {

    (addMessagesObject:)
    @NSManaged public func addToMessages(_ value: MessageCD)

    (removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: MessageCD)

    (addMessages:)
    @NSManaged public func addToMessages(_ values: NSSet)

    (removeMessages:)
    @NSManaged public func removeFromMessages(_ values: NSSet)

}
