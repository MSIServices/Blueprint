//
//  UserCD+CoreDataClass.swift
//  
//
//  Created by Stephen Muscarella on 8/15/17.
//
//

import Foundation
import UIKit
import CoreData

(UserCD)
public class UserCD: NSManagedObject {

    static func save(user: User) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        if #available(iOS 10.0, *) {
            
            let context = appDelegate.persistentContainer.viewContext
            context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            
            let userEntity = NSEntityDescription.entity(forEntityName: "UserCD", in: context)
            let newUser = NSManagedObject(entity: userEntity!, insertInto: context) as! UserCD
            
            if let userId = user.userId {
                newUser.userId = userId
            }
            if let email = user.email {
                newUser.email = email
            }
            if let username = user.username {
                newUser.username = username
            }
            if let avatar = user.avatar {
                newUser.avatar = avatar
            }
            
            do {
                try newUser.managedObjectContext?.save()
                print("Saved user...")
            } catch let err as NSError {
                print("ERROR SAVING: \(err.debugDescription)")
            }
        }
    }
    
    static func sync(user: User) -> UserCD? {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        if #available(iOS 10.0, *) {
            
            let context = appDelegate.persistentContainer.viewContext
            context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            
            let userEntity = NSEntityDescription.entity(forEntityName: "UserCD", in: context)
            let newUser: UserCD = NSManagedObject(entity: userEntity!, insertInto: context) as! UserCD

            if let userId = user.userId {
                newUser.userId = userId
            }
            if let email = user.email {
                newUser.email = email
            }
            if let username = user.username {
                newUser.username = username
            }
            if let avatar = user.avatar {
                newUser.avatar = avatar
            }
            
            do {
                try newUser.managedObjectContext?.save()
                print("Saved user...")
                
                return newUser
                
            } catch let err as NSError {
                print("ERROR SAVING: \(err.debugDescription)")
            }
        }
        return nil
    }
    
//    static func deleteAll() {
//        
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//        
//        if #available(iOS 10.0, *) {
//            
//            let context = appDelegate.persistentContainer.viewContext
//            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserCD")
//            let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
//            
//            do {
//                try context.execute(deleteRequest)
//                print("Deleted all...")
//            } catch let error as NSError {
//                print("ERROR DELETE ALL: \(error.debugDescription)")
//            }
//        }
//    }
//    
    static func fetchById(UserId: NSNumber) -> UserCD? {
        
        var User: UserCD?
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return User
        }
        
        if #available(iOS 10.0, *) {
            
            let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserCD")
            request.predicate = NSPredicate(format: "userId == %@", UserId)
            request.fetchLimit = 1
            
            do {
                User = try context.fetch(request).first as? UserCD
                print("Fetched user...")
            } catch let error as NSError {
                print("ERROR FETCHING: \(error.debugDescription)")
            }
        }
        return User
    }

    static func fetchAll() -> [UserCD] {
        
        var Users = [UserCD]()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return Users
        }
        
        if #available(iOS 10.0, *) {
            
            let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserCD")
            
            do {
                Users = try context.fetch(request) as! [UserCD]
                print("Fetched all users..")
            } catch let error as NSError {
                print("ERROR FETCHING ALL: \(error.debugDescription)")
            }
        }
        return Users
    }
//
//    static func fetchByProperty(property: UserCD) -> [UserCD] {
//        
//        var Users = [UserCD]()
//        
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return Users
//        }
//        
//        if #available(iOS 10.0, *) {
//            
//            let context = appDelegate.persistentContainer.viewContext
//            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserCD")
//            request.predicate = NSPredicate(format: "ANY <property> == %@", property)
//            
//            do {
//                Users = try context.fetch(request) as! [UserCD]
//            } catch let error as NSError {
//                print("ERROR FETCHING BY PROPERTY: \(error.debugDescription)")
//            }
//        }
//        return Users
//    }
//    
//    static func fetchByProperties(properties: [UserCD]) -> [UserCD] {
//        
//        var Users = [UserCD]()
//        
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return Users
//        }
//        
//        if #available(iOS 10.0, *) {
//            
//            let context = appDelegate.persistentContainer.viewContext
//            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserCD")
//            request.predicate = NSPredicate(format: "ANY <property> IN %@", properties)
//            
//            do {
//                Users = try context.fetch(request) as! [UserCD]
//            } catch let error as NSError {
//                print("ERROR FETCHING BY PROPERTIES: \(error.debugDescription)")
//            }
//        }
//        return Users
//    }
//    
//    static func fetchByPropertiesNotIn(properties: [UserCD]) -> [UserCD] {
//        
//        var Users = [UserCD]()
//        
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return Users
//        }
//        
//        if #available(iOS 10.0, *) {
//            
//            let context = appDelegate.persistentContainer.viewContext
//            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserCD")
//            request.predicate = NSPredicate(format: "NOT <relationship> IN %@", properties)
//            
//            do {
//                Users = try context.fetch(request) as! [UserCD]
//            } catch let error as NSError {
//                print("ERROR FETCHING BY PROPERTIES NOT IN: \(error.debugDescription)")
//            }
//        }
//        return Users
//    }

}
