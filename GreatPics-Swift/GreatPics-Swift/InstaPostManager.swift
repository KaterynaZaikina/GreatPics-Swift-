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
        
        if let posts = posts as? [[String: AnyObject]] {
            let identifiers = posts.map { String($0["id"]) }
            let predicate = NSPredicate(format: "identifier IN %@", argumentArray: [identifiers])
            fetchRequest.predicate = predicate
        }
        
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
            
            var fetchedObjectsDictionary = NSDictionary(objects: fetchedObjectArray, forKeys: fetchedObjectsIdentifiers) as? [String : InstaPost]
            print("fetchedObjectsDictionary is \(fetchedObjectsDictionary)")
            
            if let posts = posts as? NSArray {
                posts.enumerateObjectsUsingBlock { (postDictionary, index, stop) -> Void in
                    
                    let postDictionary = postDictionary as? [String: AnyObject]
                    
                    if let key = postDictionary?["id"] as? String {
                        if fetchedObjectsDictionary?[key] == nil {
                            let post = NSEntityDescription.insertNewObjectForEntityForName("InstaPost", inManagedObjectContext: self.managedObjectContext) as? InstaPost
                            post?.createdAtDate = NSDate()
                            post?.updateWithDictionary(postDictionary)
                            print("post # \(index) = \(post?.identifier)")
                        }
                    }
                }
            }
            
        }
        do {
            try self.managedObjectContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
}


