//
//  PostCD+CoreDataProperties.swift
//  
//
//  Created by Stephen Muscarella on 8/21/17.
//
//

import Foundation
import CoreData


extension PostCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PostCD> {
        return NSFetchRequest<PostCD>(entityName: "PostCD")
    }

    @NSManaged public var postId: NSNumber!
    @NSManaged public var type: String!
    @NSManaged public var text: String?
    @NSManaged public var link: String?
    @NSManaged public var image: String?
    @NSManaged public var video: String?
    @NSManaged public var audio: String?
    @NSManaged public var user: UserCD?

}
