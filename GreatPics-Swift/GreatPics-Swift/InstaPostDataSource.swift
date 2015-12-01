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

private let numberOfPosts = 3
private let fetchBatchSize = 20
private let errorDomain = "com.yalantis.GreatPics.request"
private let errorCode = 5555

protocol InstaPostDataSourceDelegate {
    
    func dataSourceWillDisplayLastCell(dataSource: InstaPostDataSource)
    func dataSourceDidChangeContent(dataSource: InstaPostDataSource)
    
}

class InstaPostDataSource: NSObject, NSFetchedResultsControllerDelegate {
    
    var delegate: InstaPostDataSourceDelegate?
    
    private(set) lazy var fetchedResultController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName:"InstaPost")
    
        fetchRequest.fetchBatchSize = fetchBatchSize
        
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
            let error = NSError(domain: errorDomain, code: errorCode, userInfo: userInfo)
            print("Unresolved error: \(error.userInfo)")
        }
        
        return fetchedResultController
        }()
    
    private let managedObjectContext: NSManagedObjectContext = CoreDataManager.sharedManager.managedObjectContext
    
    func configureCell(cell: CollectionViewCell, indexPath: NSIndexPath) {
        
        if let post = fetchedResultController.objectAtIndexPath(indexPath) as? InstaPost, let imageURL = post.imageURL {
           // cell.imageView.sd_setImageWithURL(NSURL(string: imageURL)!)
            cell.imageView.loadImageWithURL(NSURL(string: imageURL)!, placeholderImage: UIImage(named: "placeholder.png")!)
        } 
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        delegate?.dataSourceDidChangeContent(self)
    }
    
}

extension InstaPostDataSource: UICollectionViewDataSource {
    
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

extension InstaPostDataSource: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let sectionInfo: NSFetchedResultsSectionInfo? = fetchedResultController.sections?[indexPath.section]
        let numberOfItems = sectionInfo?.numberOfObjects
        if numberOfItems != nil && indexPath.item == numberOfItems! - numberOfPosts {
            delegate?.dataSourceWillDisplayLastCell(self)
        }
    }
    
}
