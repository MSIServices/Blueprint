//
//  UserCD+CoreDataProperties.swift
//  
//
//  Created by Stephen Muscarella on 8/15/17.
//
//

import Foundation
import CoreData


extension UserCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserCD> {
        return NSFetchRequest<UserCD>(entityName: "UserCD")
    }

    @NSManaged public var userId: NSNumber!
    @NSManaged public var email: String!
    @NSManaged public var username: String!
    @NSManaged public var avatar: String?
    @NSManaged public var groups: NSSet?
    @NSManaged public var posts: NSSet?

}

// MARK: Generated accessors for Groups
extension UserCD {
    
    @objc(addGroupsObject:)
    @NSManaged public func addToGroups(_ value: UserCD)
    
    @objc(removeGroupsObject:)
    @NSManaged public func removeFromGroups(_ value: UserCD)
    
    @objc(addGroups:)
    @NSManaged public func addToGroups(_ values: NSSet)
    
    @objc(removeGroups:)
    @NSManaged public func removeFromGroups(_ values: NSSet)
    
}

// MARK: Generated accessors for posts
extension UserCD {
    
    @objc(addPostsObject:)
    @NSManaged public func addToPosts(_ value: PostCD)
    
    @objc(removePostsObject:)
    @NSManaged public func removeFromPosts(_ value: PostCD)
    
    @objc(addPosts:)
    @NSManaged public func addToPosts(_ values: NSSet)
    
    @objc(removePosts:)
    @NSManaged public func removeFromPosts(_ values: NSSet)
    
}
