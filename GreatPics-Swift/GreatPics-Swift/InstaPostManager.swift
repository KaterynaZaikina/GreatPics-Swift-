//
//  InstaPostManager.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 11/24/15.
//  Copyright © 2015 kateryna.zaikina. All rights reserved.
//

import Foundation
import CoreData
import FastEasyMapping

class InstaPostManager {
    
    private let managedObjectContext = CoreDataManager.sharedManager.managedObjectContext
    
    func importPost(posts: AnyObject) {
        
        let privateContext = CoreDataManager.sharedManager.importContext
        
        privateContext.performBlock {
            let fetchRequest = NSFetchRequest()
            let entity = NSEntityDescription.entityForName("InstaPost", inManagedObjectContext: privateContext)
            fetchRequest.entity = entity
            
            guard let posts = posts as? [[String: AnyObject]] else {
                return
            }
            let identifiers = posts.flatMap { $0["id"] as? String }
            
            let predicate = NSPredicate(format: "identifier IN %@", argumentArray: [identifiers])
            fetchRequest.predicate = predicate
            
            var fetchedObjectArray: [InstaPost]?
            do {
                fetchedObjectArray = try privateContext.executeFetchRequest(fetchRequest) as? [InstaPost]
                
            } catch let error as NSError {
                print("Error: \(error.localizedDescription)")
                fetchedObjectArray = nil
            }
            
            var fetchedObjectsIdentifiers: [String]
            if let fetchedObjectArray = fetchedObjectArray {
                fetchedObjectsIdentifiers = fetchedObjectArray.flatMap{ $0.identifier }
                
                var fetchedObjectsDictionary = NSDictionary(objects: fetchedObjectArray,
                    forKeys: fetchedObjectsIdentifiers) as? [String : InstaPost]
                
                for var postDictionary: [String: AnyObject] in posts {
                    if let key = postDictionary["id"] as? String {
                        var post: InstaPost!
                        if let existPost = fetchedObjectsDictionary?[key] {
                            post = existPost
                        }  else {
                            
//                            post = NSEntityDescription.insertNewObjectForEntityForName("InstaPost",
//                                inManagedObjectContext: self.managedObjectContext) as? InstaPost
                            post = FEMManagedObjectDeserializer.deserializeObjectExternalRepresentation(postDictionary, usingMapping: InstaPost.defaultMapping(), context: self.managedObjectContext) as? InstaPost
                            
                            post.createdAtDate = NSDate()
                        }
                       // post?.updateWithDictionary(postDictionary)
//                        FEMManagedObjectDeserializer.fillObject(post, fromExternalRepresentation: postDictionary, usingMapping: InstaPost.defaultMapping())
                    }
                }
            }
            CoreDataManager.sharedManager.saveImportContext(privateContext)
        }
    }
    
}


