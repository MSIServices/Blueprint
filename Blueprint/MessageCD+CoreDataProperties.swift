//
//  MessageCD+CoreDataProperties.swift
//  
//
//  Created by Stephen Muscarella on 9/7/17.
//
//

import Foundation
import CoreData

extension MessageCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MessageCD> {
        return NSFetchRequest<MessageCD>(entityName: "MessageCD")
    }

    @NSManaged public var messageId: NSNumber!
    @NSManaged public var text: String!
    @NSManaged public var timestamp: NSDate!
    @NSManaged public var sender: UserCD?
    @NSManaged public var conversation: ConversationCD?

}
