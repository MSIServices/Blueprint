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
    @NSManaged public var email: String?
    @NSManaged public var username: String?
    @NSManaged public var avatar: String?
    @NSManaged public var groups: NSSet?
    @NSManaged public var posts: NSSet?
    @NSManaged public var messages: NSSet?
    @NSManaged public var conversations: NSSet?

}

// MARK: Generated accessors for Groups
extension UserCD {
    
    @objc(addGroupsObject:)
    @NSManaged public func addToGroups(_ value: GroupCD)
    
    @objc(removeGroupsObject:)
    @NSManaged public func removeFromGroups(_ value: GroupCD)
    
    @objc(addGroups:)
    @NSManaged public func addToGroups(_ values: NSSet)
    
    @objc(removeGroups:)
    @NSManaged public func removeFromGroups(_ values: NSSet)
    
}

// MARK: Generated accessors for Posts
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

// MARK: Generated accessors for Messages
extension UserCD {
    
    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: MessageCD)
    
    @objc(removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: MessageCD)
    
    @objc(addMessages:)
    @NSManaged public func addToMessages(_ values: NSSet)
    
    @objc(removeMessages:)
    @NSManaged public func removeFromMessages(_ values: NSSet)
    
}

// MARK: Generated accessors for Conversations
extension UserCD {
    
    @objc(addConversationsObject:)
    @NSManaged public func addToConversations(_ value: ConversationCD)
    
    @objc(removeConversationsObject:)
    @NSManaged public func removeFromConversations(_ value: ConversationCD)
    
    @objc(addConversations:)
    @NSManaged public func addToConversations(_ values: NSSet)
    
    @objc(removeConversations:)
    @NSManaged public func removeFromConversations(_ values: NSSet)
    
}
