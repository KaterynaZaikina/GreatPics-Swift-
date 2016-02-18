//
//  CoreDataManager.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 11/24/15.
//  Copyright © 2015 kateryna.zaikina. All rights reserved.
//

import Foundation
import CoreData

private struct Constants {
    
    struct Errors {
        static let errorCode = 9999
        static let errorDomain = "com.yalantis.GreatPics.database"
        static let loadError = "There was an error creating or loading the application's saved data."
        static let initError = "Failed to initialize the application's saved data"
    }
    
    struct CoreData {
        static let resource = "GreatPics_Swift"
        static let bundleExtension = "momd"
        static let directory = "SingleViewCoreData.sqlite"
    }
    
}

final public class CoreDataManager {
    
    static let sharedManager = CoreDataManager()
    lazy var importContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        context.parentContext = self.managedObjectContext
        return context
    }()
    
    // MARK: - Core Data stack
    private lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
//MARK: Code_Review_18.02.2016: '[urls.count - 1]'
        return urls[urls.count-1]
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource(Constants.CoreData.resource, withExtension: Constants.CoreData.bundleExtension)!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent(Constants.CoreData.directory)
        var failureReason = Constants.Errors.loadError
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            var errorUserInfo = [String: AnyObject]()
            errorUserInfo[NSLocalizedDescriptionKey] = Constants.Errors.initError
            errorUserInfo[NSLocalizedFailureReasonErrorKey] = failureReason
            
            errorUserInfo[NSUnderlyingErrorKey] = error as NSError
            
            let wrappedError = NSError(domain: Constants.Errors.errorDomain, code: Constants.Errors.errorCode, userInfo: errorUserInfo)
            print("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            assertionFailure(wrappedError.localizedDescription)
        }
        
        return coordinator
    }()
    
    private(set) lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        managedObjectContext.performBlock { [unowned self] in
            if self.managedObjectContext.hasChanges {
                do {
                    try self.managedObjectContext.save()
                    
                } catch {
                    let coreDataError  = error as NSError
                    print("Unresolved error \(coreDataError), \(coreDataError .userInfo)")
                    assertionFailure(coreDataError.localizedDescription)
                }
            }
        }
    }
    
    func saveImportContext(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        saveContext()
    }
    
}


