//
//  GroupCD+CoreDataProperties.swift
//  
//
//  Created by Stephen Muscarella on 8/21/17.
//
//

import Foundation
import CoreData


extension GroupCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GroupCD> {
        return NSFetchRequest<GroupCD>(entityName: "GroupCD")
    }

    @NSManaged public var groupId: NSNumber!
    @NSManaged public var name: String!
    @NSManaged public var descrip: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var members: NSSet?

}

// MARK: Generated accessors for members
extension GroupCD {

    (addMembersObject:)
    @NSManaged public func addToMembers(_ value: UserCD)

    (removeMembersObject:)
    @NSManaged public func removeFromMembers(_ value: UserCD)

    (addMembers:)
    @NSManaged public func addToMembers(_ values: NSSet)

    (removeMembers:)
    @NSManaged public func removeFromMembers(_ values: NSSet)

}
