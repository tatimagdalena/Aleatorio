//
//  ActiveCoreData.swift
//  ActiveCoreData-Example
//
//  Created by Jaison Vieira on 7/21/16.
//  Copyright © 2016 jaisonv. All rights reserved.
//

import CoreData

extension NSManagedObject {
        
    class func findAll() -> NSArray {
        
        let entityName = NSStringFromClass(self).componentsSeparatedByString(".").last!
        
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext: ActiveCoreData.sharedController.managedObjectContext!)
    
        fetchRequest.entity = entity
        
        var fetchedObjects = []
        
        do {
         
            fetchedObjects = try ActiveCoreData.sharedController.managedObjectContext!.executeFetchRequest(fetchRequest)
        }
        catch let error as NSError {
            
            NSLog("\(error.localizedDescription)")
        }
        
        return fetchedObjects
    }
    
    class func findAllByAttribute(attribute: String, value: String) -> NSArray {
        
        if attribute == "" || value == "" {
            
            return []
        }
        
        let predicate = NSPredicate(format: "%K = %@", attribute, value)
        let entityName = NSStringFromClass(self).componentsSeparatedByString(".").last!
        
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext: ActiveCoreData.sharedController.managedObjectContext!)
        
        fetchRequest.entity = entity
        fetchRequest.predicate = predicate
        
        var fetchedObjects = []
        
        do {
            
            fetchedObjects = try ActiveCoreData.sharedController.managedObjectContext!.executeFetchRequest(fetchRequest)
        }
        catch let error as NSError {
            
            NSLog("\(error.localizedDescription)")
        }
        
        return fetchedObjects
    }
    
    class func findFirst() -> Self? {
        
        return findFirstHelper()
    }
    
    private class func findFirstHelper<T>() -> T? {
        
        let entityName = NSStringFromClass(self).componentsSeparatedByString(".").last!
        
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext: ActiveCoreData.sharedController.managedObjectContext!)
        
        fetchRequest.entity = entity
        
        var fetchedObjects = []
        
        do {
            
            fetchedObjects = try ActiveCoreData.sharedController.managedObjectContext!.executeFetchRequest(fetchRequest)
        }
        catch let error as NSError {
            
            NSLog("\(error.localizedDescription)")
        }
        
        if fetchedObjects.count > 0 {
            
            return fetchedObjects.firstObject as? T
        }
        
        return nil
    }
    
    class func findFirstByAttribute(attribute: String, value: String) -> Self? {
        
        return findFirstByAttributeHelper(attribute, value: value)
    }
    
    private class func findFirstByAttributeHelper<T>(attribute: String, value: String) -> T? {
        
        if attribute == "" || value == "" {
            
            return nil
        }
        
        let predicate = NSPredicate(format: "%K = %@", attribute, value)
        let entityName = NSStringFromClass(self).componentsSeparatedByString(".").last!
        
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext: ActiveCoreData.sharedController.managedObjectContext!)
        
        fetchRequest.entity = entity
        fetchRequest.predicate = predicate
        
        var fetchedObjects = []
        
        do {
            
            fetchedObjects = try ActiveCoreData.sharedController.managedObjectContext!.executeFetchRequest(fetchRequest)
        }
        catch let error as NSError {
            
            NSLog("\(error.localizedDescription)")
        }
        
        if fetchedObjects.count > 0 {
            
            return fetchedObjects.firstObject as? T
        }
        
        return nil
    }

    class func create() -> Self {
        
        return createHelper()
    }
    
    private class func createHelper<T>() -> T {
        
        let entityName = NSStringFromClass(self).componentsSeparatedByString(".").last!
        return NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: ActiveCoreData.sharedController.managedObjectContext!) as! T
    }
    
    func delete() {
        
        ActiveCoreData.sharedController.managedObjectContext?.deleteObject(self)
        save()
    }
    
    func save() {
        
        do {
            try ActiveCoreData.sharedController.managedObjectContext?.save()
        }
        catch let error as NSError {
            
            NSLog("\(error.localizedDescription)")
        }
    }
}

public class ActiveCoreData: NSObject {

    static let sharedController = ActiveCoreData()
    
    var managedObjectModel: NSManagedObjectModel?
    var persistentStoreCoordinator: NSPersistentStoreCoordinator?
    var managedObjectContext: NSManagedObjectContext?
    
    override init() {
        
        super.init()
        
        let bundle = NSBundle.mainBundle()
        let bundleName = NSBundle.mainBundle().infoDictionary!["CFBundleName"] as! String
        
        // init managedObjectModel
        let modelUrl = bundle.URLForResource(bundleName, withExtension: "momd")
        
        if let result = modelUrl {
            
            self.managedObjectModel = NSManagedObjectModel.init(contentsOfURL: result)!
        }
        
        // init persistentStoreCoordinator
        if let manageObject = self.managedObjectModel {
            
            self.persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: manageObject)
            let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
            let storeUrl = self.applicationDocumentsDirectory.URLByAppendingPathComponent("\(bundleName).sqlite")
            
            do {
                
                try self.persistentStoreCoordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeUrl, options: options)
            }
            catch let error as NSError {
                
                NSLog("\(error.localizedDescription)")
                persistentStoreCoordinator = nil
            }
        }
        
        // init managedObjectContex
        if let coordinator = self.persistentStoreCoordinator {
            
            self.managedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
            self.managedObjectContext?.persistentStoreCoordinator = coordinator
        }
    }
    
    var applicationDocumentsDirectory: NSURL {
        
        let bundleId = NSBundle.mainBundle().bundleIdentifier
        
        let libraryPath = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true).last
        let path = (libraryPath! as NSString).stringByAppendingPathComponent(bundleId!)
        
        var isDirectory: ObjCBool = false
        let fileManager = NSFileManager.defaultManager()
        
        if !fileManager.fileExistsAtPath(path, isDirectory: &isDirectory) {
            
            do {
                
                try fileManager.createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil)
                
            } catch let error as NSError {
                
                NSLog("Can't create directory \(path) [\(error.localizedDescription)]")
            }
            
        } else if !isDirectory {
            
            NSLog("Path \(path) exists but is no directory")
        }
        
        return NSURL.fileURLWithPath(path)
    }
    
    func saveContext() {
        
        if let context = self.managedObjectContext {
            
            do {
                if context.hasChanges {
                    
                    try context.save()
                }
            }
            catch let error as NSError {
                
                NSLog("\(error.localizedDescription)")
            }
        }
    }
}
