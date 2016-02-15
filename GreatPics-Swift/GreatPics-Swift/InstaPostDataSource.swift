//
//  DataSource.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 11/26/15.
//  Copyright © 2015 kateryna.zaikina. All rights reserved.
//

import UIKit
import CoreData

private let cFetchBatchSize = 20
private let cErrorCode = 5555
private let cFontSize: CGFloat = 14.0
private let kErrorDomain = "com.yalantis.GreatPics.request"
private let kPlaceholder = "placeholder.png"
private let kFontName = "Helvetica Neue"


//MARK: - InstaPostDataSource class
class InstaPostDataSource: NSObject {
    
    let collectionView: UICollectionView
    
    private var blockOperations: [NSBlockOperation] = []
    private(set) lazy var fetchedResultController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName:"InstaPost")
        
        fetchRequest.fetchBatchSize = cFetchBatchSize
        
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
            let error = NSError(domain: kErrorDomain, code: cErrorCode, userInfo: userInfo)
            print("Unresolved error: \(error.userInfo)")
        }
        
        return fetchedResultController
    }()
    
    private let managedObjectContext: NSManagedObjectContext = CoreDataManager.sharedManager.managedObjectContext
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
    
    func configureCell(cell: CollectionViewCell, indexPath: NSIndexPath) {
        if let post = fetchedResultController.objectAtIndexPath(indexPath) as? InstaPost, let imageURL = post.imageURL  {
            cell.imageView.loadImageWithURL(NSURL(string: imageURL), placeholderImage: UIImage(named: kPlaceholder)!)
            if let text = post.text {
            cell.textLabel.text = text
            }
        }
    }
    
}

//MARK: - FetchedresultsControllerDelegate
extension InstaPostDataSource: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        blockOperations.removeAll(keepCapacity: false)
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            if let newIndexPath = newIndexPath {
                blockOperations.append(
                    NSBlockOperation(block: { [unowned self] in
                        self.collectionView.insertItemsAtIndexPaths([newIndexPath])
                        })
                )
            }
        case .Update:
            if let indexPath = indexPath {
                blockOperations.append(
                    NSBlockOperation(block: { [unowned self] in
                        self.collectionView.reloadItemsAtIndexPaths([indexPath])
                        })
                )
            }
        default:
            break
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        collectionView.performBatchUpdates({ [unowned self] in
            for operation in self.blockOperations {
                operation.start()
            }
            }, completion: { [unowned self] finished in
                self.blockOperations.removeAll(keepCapacity: false)
            })
    }
    
    func postAtIndexPath(indexPath: NSIndexPath) -> InstaPost? {
        let post = fetchedResultController.objectAtIndexPath(indexPath) as? InstaPost
        return post
    }
    
    func numberOfItemsAtIndexPath(indexPath: NSIndexPath) -> Int? {
        let sectionInfo = fetchedResultController.sections?[indexPath.section]
        let numberOfItems = sectionInfo?.numberOfObjects
        return numberOfItems
    }
    
}

//MARK: - UICollectionViewDataSource
extension InstaPostDataSource: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionInfo: NSFetchedResultsSectionInfo? = fetchedResultController.sections?[section]
        return sectionInfo?.numberOfObjects ?? 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CollectionViewCell.reuseIdentifier, forIndexPath: indexPath) as! CollectionViewCell
        configureCell(cell, indexPath: indexPath)
        return cell
    }
    
}

//MARK: - PinterestLayoutDelegate
extension InstaPostDataSource: PinterestLayoutDelegate {
    
    func collectionView(collectionView: UICollectionView, heightForCommentAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
            let post = fetchedResultController.objectAtIndexPath(indexPath) as! InstaPost
            let font = UIFont(name: kFontName, size: cFontSize)!
            let height = post.heightForComment(font, width: width)
            return height
    }
}


