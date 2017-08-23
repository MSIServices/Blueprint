//
//  TemplateCD.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/9/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import Foundation
import UIKit
import CoreData

@objc(TemplateCD)
public class TemplateCD: NSManagedObject {
    
//    static func save(data: Any)  {
//        
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//        
//        if #available(iOS 10.0, *) {
//            
//            let context = appDelegate.persistentContainer.viewContext
//            
//            let templateEntity = NSEntityDescription.entity(forEntityName: "TemplateCD", in: context)
//            let newTemplate = NSManagedObject(entity: templateEntity!, insertInto: context) as! TemplateCD
//            
//            /*.................................
//              Set Properties
//            ...................................*/
//            
//            do {
//                try newTemplate.managedObjectContext?.save()
//                print("Saved...")
//            } catch let err as NSError {
//                print("ERROR SAVING: \(err.debugDescription)")
//            }
//        }
//    }
//    
//    static func deleteAll() {
//        
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//        
//        if #available(iOS 10.0, *) {
//            
//            let context = appDelegate.persistentContainer.viewContext
//            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TemplateCD")
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
//    static func fetchById(templateId: String) -> TemplateCD? {
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
//            request.predicate = NSPredicate(format: "templateId == %@", templateId)
//            request.fetchLimit = 1
//            
//            do {
//                template = try context.fetch(request).first as? TemplateCD
//                print("Fetched...")
//            } catch let error as NSError {
//                print("ERROR FETCHING: \(error.debugDescription)")
//            }
//        }
//        return template
//    }
//    
//    static func fetchAll() -> [TemplateCD] {
//        
//        var templates = [TemplateCD]()
//        
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return templates
//        }
//        
//        if #available(iOS 10.0, *) {
//            
//            let context = appDelegate.persistentContainer.viewContext
//            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TemplateCD")
//
//            do {
//                templates = try context.fetch(request) as! [TemplateCD]
//                print("Fetched all...")
//            } catch let error as NSError {
//                print("ERROR FETCHING ALL: \(error.debugDescription)")
//            }
//        }
//        return templates
//    }
//    
//    static func fetchByProperty(property: TemplateCD) -> [TemplateCD] {
//        
//        var templates = [TemplateCD]()
//        
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return templates
//        }
//        
//        if #available(iOS 10.0, *) {
//            
//            let context = appDelegate.persistentContainer.viewContext
//            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TemplateCD")
//            request.predicate = NSPredicate(format: "ANY <property> == %@", property)
//            
//            do {
//                templates = try context.fetch(request) as! [TemplateCD]
//            } catch let error as NSError {
//                print("ERROR FETCHING BY PROPERTY: \(error.debugDescription)")
//            }
//        }
//        return templates
//    }
//    
//    static func fetchByProperties(properties: [TemplateCD]) -> [TemplateCD] {
//
//        var templates = [TemplateCD]()
//        
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return templates
//        }
//        
//        if #available(iOS 10.0, *) {
//            
//            let context = appDelegate.persistentContainer.viewContext
//            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TemplateCD")
//            request.predicate = NSPredicate(format: "ANY <property> IN %@", properties)
//            
//            do {
//                templates = try context.fetch(request) as! [TemplateCD]
//            } catch let error as NSError {
//                print("ERROR FETCHING BY PROPERTIES: \(error.debugDescription)")
//            }
//        }
//        return templates
//    }
//    
//    static func fetchByPropertiesNotIn(properties: [TemplateCD]) -> [TemplateCD] {
//        
//        var templates = [TemplateCD]()
//        
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return templates
//        }
//        
//        if #available(iOS 10.0, *) {
//            
//            let context = appDelegate.persistentContainer.viewContext
//            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TemplateCD")
//            request.predicate = NSPredicate(format: "NOT <relationship> IN %@", properties)
//            
//            do {
//                templates = try context.fetch(request) as! [TemplateCD]
//            } catch let error as NSError {
//                print("ERROR FETCHING BY PROPERTIES NOT IN: \(error.debugDescription)")
//            }
//        }
//        return templates
//    }
    
}
