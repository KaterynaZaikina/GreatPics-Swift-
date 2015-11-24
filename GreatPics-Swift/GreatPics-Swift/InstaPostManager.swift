//
//  InstaPostManager.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 11/24/15.
//  Copyright © 2015 kateryna.zaikina. All rights reserved.
//

import Foundation
import CoreData

class InstaPostManager {
    
    private let managedObjectContext = CoreDataManager.sharedManager.managedObjectContext
    
    func importPost(posts: [[String : AnyObject]]?) {
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("InstaPost", inManagedObjectContext: managedObjectContext)
        fetchRequest.entity = entity
        
        if let posts = posts {
            let identifiers = posts.map { $0["id"] }
            let predicate = NSPredicate(format: "identifier IN \(identifiers)")
            fetchRequest.predicate = predicate
            
            var fetchedObjectArray: [InstaPost]?
            
            do {
                fetchedObjectArray = try managedObjectContext.executeFetchRequest(fetchRequest) as? [InstaPost]
            } catch let error as NSError {
                print("Error: \(error.localizedDescription)")
                fetchedObjectArray = nil
            }
            
            var fetchedObjectsIdentifiers: [String?]
            if let fetchedObjectArray = fetchedObjectArray {
                fetchedObjectsIdentifiers = fetchedObjectArray.map { $0.identifier }
            }
            
            // NSDictionary *fetchedObjectsDictionary = [NSDictionary dictionaryWithObjects:fetchedObjectsArray forKeys:fetchedObjectsIdentifiers];
            
        }
        
    }


}
