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
    
    func importPost(posts: AnyObject) {
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("InstaPost", inManagedObjectContext: managedObjectContext)
        fetchRequest.entity = entity
        
        guard let posts = posts as? [[String: AnyObject]] else {
            return
        }
        
        let identifiers = posts.map { String($0["id"]) }
        let predicate = NSPredicate(format: "identifier IN %@", argumentArray: [identifiers])
        fetchRequest.predicate = predicate
        
        
        var fetchedObjectArray: [InstaPost]?
        
        do {
            fetchedObjectArray = try managedObjectContext.executeFetchRequest(fetchRequest) as? [InstaPost]
            print("fetchedObjectArray is \(fetchedObjectArray)")
            
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
            fetchedObjectArray = nil
        }
        
        var fetchedObjectsIdentifiers: [String]
        if let fetchedObjectArray = fetchedObjectArray {
            fetchedObjectsIdentifiers = fetchedObjectArray.map { $0.identifier! }
            
            var fetchedObjectsDictionary = NSDictionary(objects: fetchedObjectArray,
                forKeys: fetchedObjectsIdentifiers) as? [String : InstaPost]
            print("fetchedObjectsDictionary is \(fetchedObjectsDictionary)")
            
            
            for var postDictionary: [String: AnyObject] in posts {
                if let key = postDictionary["id"] as? String {
                    var post: InstaPost!
                    if fetchedObjectsDictionary?[key] == nil {
                        post = NSEntityDescription.insertNewObjectForEntityForName("InstaPost",
                            inManagedObjectContext: self.managedObjectContext) as? InstaPost
                        post.createdAtDate = NSDate()
                    } else {
                        post = fetchedObjectsDictionary?[key]
                    }
                    post?.updateWithDictionary(postDictionary)
                }
            }
        }
        do {
            try self.managedObjectContext.save()
        } catch {
            print("Failure to save context: \(error)")
        }
    }
    
}


