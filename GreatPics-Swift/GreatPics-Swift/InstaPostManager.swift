//
//  InstaPostManager.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 11/24/15.
//  Copyright © 2015 kateryna.zaikina. All rights reserved.
//

import Foundation
import CoreData

private struct Constants {
    static let entityName = "InstaPost"
    static let id = "id"
}

final public class InstaPostManager {
    
    private let managedObjectContext = CoreDataManager.sharedManager.managedObjectContext
    
    //MARK: - Public methods
    func importPost(posts: AnyObject) {
        let privateContext = CoreDataManager.sharedManager.importContext
        
        privateContext.performBlock {
            let fetchRequest = NSFetchRequest()
            let entity = NSEntityDescription.entityForName(Constants.entityName, inManagedObjectContext: privateContext)
            fetchRequest.entity = entity
            
            guard let posts = posts as? [[String: AnyObject]] else {
                return
            }
            let identifiers = posts.flatMap { $0[Constants.id] as? String }
            
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
                    if let key = postDictionary[Constants.id] as? String {
                        var post: InstaPost!
                        if let existPost = fetchedObjectsDictionary?[key] {
                            post = existPost
                        }  else {
                            post = NSEntityDescription.insertNewObjectForEntityForName(Constants.entityName,
                                inManagedObjectContext: self.managedObjectContext) as? InstaPost
                            
                            post.createdAtDate = NSDate()
                        }
                        post?.updateWithDictionary(postDictionary)
                    }
                }
            }
            CoreDataManager.sharedManager.saveImportContext(privateContext)
        }
    }
    
}


