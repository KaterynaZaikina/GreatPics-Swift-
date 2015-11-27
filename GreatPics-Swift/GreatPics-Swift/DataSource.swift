//
//  DataSource.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 11/26/15.
//  Copyright © 2015 kateryna.zaikina. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import AFNetworking
import SDWebImage

protocol DataSourceDelegate {
    
    func dataSourceWillDisplayLastCell(dataSource: DataSource)
    func dataSourceDidChangeContent(dataSource: DataSource)
    
}

class DataSource: NSObject, NSFetchedResultsControllerDelegate {
    
    var delegate: DataSourceDelegate?
    
    private(set) lazy var fetchedResultController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName:"InstaPost")
        
        let kFetchBatchSize = 20;
        fetchRequest.fetchBatchSize = kFetchBatchSize
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAtDate", ascending: true)]
        let fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        fetchedResultController.delegate = self
        
        do {
            try fetchedResultController.performFetch() }
        catch {
            var userInfo = [String: AnyObject]()
            userInfo[NSLocalizedDescriptionKey] = "Failed to fetch request"
            let error = NSError(domain: "com.yalantis.GreatPics.request", code: 5555, userInfo: userInfo)
            print("Unresolved error: \(error.userInfo)")
        }
        
        return fetchedResultController
        }()
    
    private let managedObjectContext: NSManagedObjectContext = CoreDataManager.sharedManager.managedObjectContext
    
    func configureCell(cell: CollectionViewCell, indexPath: NSIndexPath) {
        
        if let post = fetchedResultController.objectAtIndexPath(indexPath) as? InstaPost, let imageURL = post.imageURL {
            cell.imageView.sd_setImageWithURL(NSURL(string: imageURL)!)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        delegate?.dataSourceDidChangeContent(self)
    }
    
}

extension DataSource: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionInfo: NSFetchedResultsSectionInfo? = fetchedResultController.sections?[section]
        if sectionInfo?.numberOfObjects != nil {
            return sectionInfo!.numberOfObjects
        } else {
            return 1
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let reuseIdentifier = "CollectionViewCell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CollectionViewCell
        configureCell(cell, indexPath: indexPath)
        return cell
    }
    
}

extension DataSource: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let sectionInfo: NSFetchedResultsSectionInfo? = fetchedResultController.sections?[indexPath.section]
        let numberOfItems = sectionInfo?.numberOfObjects
        let numberOfPosts = 3
        if numberOfItems != nil && indexPath.item == numberOfItems! - numberOfPosts {
            delegate?.dataSourceWillDisplayLastCell(self)
        }
    }
    
}
