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

    @NSManaged public var userId: NSNumber?
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
    
    (addGroupsObject:)
    @NSManaged public func addToGroups(_ value: GroupCD)
    
    (removeGroupsObject:)
    @NSManaged public func removeFromGroups(_ value: GroupCD)
    
    (addGroups:)
    @NSManaged public func addToGroups(_ values: NSSet)
    
    (removeGroups:)
    @NSManaged public func removeFromGroups(_ values: NSSet)
    
}

// MARK: Generated accessors for Posts
extension UserCD {
    
    (addPostsObject:)
    @NSManaged public func addToPosts(_ value: PostCD)
    
    (removePostsObject:)
    @NSManaged public func removeFromPosts(_ value: PostCD)
    
    (addPosts:)
    @NSManaged public func addToPosts(_ values: NSSet)
    
    (removePosts:)
    @NSManaged public func removeFromPosts(_ values: NSSet)
    
}

// MARK: Generated accessors for Messages
extension UserCD {
    
    (addMessagesObject:)
    @NSManaged public func addToMessages(_ value: MessageCD)
    
    (removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: MessageCD)
    
    (addMessages:)
    @NSManaged public func addToMessages(_ values: NSSet)
    
    (removeMessages:)
    @NSManaged public func removeFromMessages(_ values: NSSet)
    
}

// MARK: Generated accessors for Conversations
extension UserCD {
    
    (addConversationsObject:)
    @NSManaged public func addToConversations(_ value: ConversationCD)
    
    (removeConversationsObject:)
    @NSManaged public func removeFromConversations(_ value: ConversationCD)
    
    (addConversations:)
    @NSManaged public func addToConversations(_ values: NSSet)
    
    (removeConversations:)
    @NSManaged public func removeFromConversations(_ values: NSSet)
    
}
