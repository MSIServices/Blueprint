//
//  TemplateCD+Properties.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/9/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import Foundation
import UIKit
import CoreData

//extension TemplateCD {
//    
//    @nonobjc public class func fetchRequest() -> NSFetchRequest<TemplateCD> {
//        return NSFetchRequest<TemplateCD>(entityName: "TemplateCD")
//    }
//    
//    @NSManaged public var templateId: String?
//    @NSManaged public var name: String?
//    @NSManaged public var timestamp: NSDate?
//    @NSManaged public var relationships: NSSet?
//    
//    func addRelationship(relationship: TemplateCD) {
//        
//        let tempSet = NSMutableSet(set: self.relationships!)
//        tempSet.add(relationship)
//        self.relationships = tempSet
//    }
//    
//    func saveRelationship(relationship: TemplateCD) {
//        
//        if #available(iOS 10.0, *) {
//            
//            self.addRelationship(relationship: relationship)
//            
//            do {
//                try self.managedObjectContext?.save()
//                print("Saving relationship...")
//            } catch let error as NSError {
//                print("ERROR SAVING RELATIONSHIP: \(error.debugDescription)")
//            }
//        }
//    }
//    
//    func fetchRelationships() -> [TemplateCD] {
//        
//        var relationships = [TemplateCD]()
//        
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return relationships
//        }
//        
//        if #available(iOS 10.0, *) {
//            
//            let context = appDelegate.persistentContainer.viewContext
//            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TemplateCD")
//            request.predicate = NSPredicate(format: "ANY <self> == %@", self as CVarArg)
//            
//            do {
//                relationships = try context.fetch(request) as! [TemplateCD]
//                print("Fetching relationships...")
//            } catch let error as NSError {
//                print("ERROR FETCHING RELATIONSHIPS: \(error.debugDescription)")
//            }
//        }
//        return relationships
//    }
//    
//    func fetchLastRelationship() -> TemplateCD? {
//        
//        var template: TemplateCD?
//        
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return template
//        }
//        
//        if #available(iOS 10.0, *) {
//            
//            let context = appDelegate.persistentContainer.viewContext
//            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TemplateCD")
//            request.predicate = NSPredicate(format: "ANY <self> == %@", self)
//            let sectionSortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
//            request.sortDescriptors = [sectionSortDescriptor]
//            request.fetchLimit = 1
//            
//            do {
//                template = try context.fetch(request).first as? TemplateCD
//                print("Fetched last relationship...")
//            } catch let error as NSError {
//                print("ERROR FETCHING LAST RELATIONSHIP: \(error.debugDescription)")
//            }
//        }
//        return template
//    }
//    
//}
//
//// MARK: Generated accessors for participants
//extension TemplateCD {
//    
//    @objc(addParticipantsObject:)
//    @NSManaged public func addToParticipants(_ value: TemplateCD)
//    
//    @objc(removeParticipantsObject:)
//    @NSManaged public func removeFromParticipants(_ value: TemplateCD)
//    
//    @objc(addParticipants:)
//    @NSManaged public func addToParticipants(_ values: NSSet)
//    
//    @objc(removeParticipants:)
//    @NSManaged public func removeFromParticipants(_ values: NSSet)
//    
//}
