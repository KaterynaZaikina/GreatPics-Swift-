//
//  CoreDataManager.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 11/24/15.
//  Copyright © 2015 kateryna.zaikina. All rights reserved.
//

import Foundation
import CoreData

private let errorDomain = "com.yalantis.GreatPics.database"
private let errorCode = 9999

class CoreDataManager {
    
    static let sharedManager = CoreDataManager()

    // MARK: - Core Data stack
    private lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
        }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource("GreatPics_Swift", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            var errorUserInfo = [String: AnyObject]()
            errorUserInfo[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            errorUserInfo[NSLocalizedFailureReasonErrorKey] = failureReason
            
            errorUserInfo[NSUnderlyingErrorKey] = error as? NSError
            
            let wrappedError = NSError(domain: errorDomain, code: errorCode, userInfo: errorUserInfo)
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
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
                
            } catch {
                let coreDataError  = error as NSError
                print("Unresolved error \(coreDataError), \(coreDataError .userInfo)")
                assertionFailure(coreDataError.localizedDescription)
            }
        }
    }

}


