//
//  PostCD+CoreDataClass.swift
//  
//
//  Created by Stephen Muscarella on 8/21/17.
//
//

import Foundation
import CoreData

(PostCD)
public class PostCD: NSManagedObject {

    static func save(post: Post) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        if #available(iOS 10.0, *) {
            
            let context = appDelegate.persistentContainer.viewContext
            let postEntity = NSEntityDescription.entity(forEntityName: "PostCD", in: context)
            let newPost = NSManagedObject(entity: postEntity!, insertInto: context) as! PostCD
            
            newPost.postId = post.postId as NSNumber
            newPost.type = post.type
            newPost.text = post.text
            newPost.link = post.link
            newPost.image = post.image
            newPost.video = post.video
            newPost.audio = post.audio
            newPost.user = UserCD.fetchById(UserId: User.currentId)
            
            do {
                try newPost.managedObjectContext?.save()
                print("Saved post...")
            } catch let err as NSError {
                print("ERROR SAVING: \(err.debugDescription)")
            }
        }
    }

}
