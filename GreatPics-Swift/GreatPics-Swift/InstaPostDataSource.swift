//
//  DataSource.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 11/26/15.
//  Copyright © 2015 kateryna.zaikina. All rights reserved.
//

import UIKit
import CoreData

private let cFetchBatchSize = 5
private let cErrorCode = 5555
private let cFontSize: CGFloat = 14.0
private let kErrorDomain = "com.yalantis.GreatPics.request"
private let kPlaceholder = "placeholder.png"
private let kFontName = "Helvetica Neue"


//MARK: - InstaPostDataSource class
class InstaPostDataSource: NSObject {
    
    private var collectionView: UICollectionView?
    private var tableView: UITableView?
    private var fetchOffset: NSInteger = 0
    var data = [AnyObject]()
    
    private var blockOperations: [NSBlockOperation] = []
   
    /*
    private(set) lazy var fetchedResultController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName:"InstaPost")
        
        fetchRequest.fetchBatchSize = cFetchBatchSize
        fetchRequest.fetchLimit = cFetchBatchSize
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAtDate", ascending: true)]
        let fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        fetchedResultController.delegate = self
        
        do {
            try fetchedResultController.performFetch()
        } catch {
            var userInfo = [String: AnyObject]()
            userInfo[NSLocalizedDescriptionKey] = "Failed to fetch request"
            let error = NSError(domain: kErrorDomain, code: cErrorCode, userInfo: userInfo)
            print("Unresolved error: \(error.userInfo)")
        }
        
        return fetchedResultController
    }()
    */
    
    private let managedObjectContext: NSManagedObjectContext = CoreDataManager.sharedManager.managedObjectContext
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
    
    init(tableView: UITableView) {
        self.tableView = tableView
    }
    
    func fetchRequestWithOffset(offset: NSInteger) -> [AnyObject] {
        let fetchRequest = NSFetchRequest(entityName:"InstaPost")
        
        fetchRequest.fetchBatchSize = cFetchBatchSize
        fetchRequest.fetchLimit = cFetchBatchSize
        fetchRequest.fetchOffset = offset
        do {
            return try managedObjectContext.executeFetchRequest(fetchRequest)
        } catch {
            var userInfo = [String: AnyObject]()
            userInfo[NSLocalizedDescriptionKey] = "Failed to fetch request"
            let error = NSError(domain: kErrorDomain, code: cErrorCode, userInfo: userInfo)
            print("Unresolved error: \(error.userInfo)")
        }
        return []
    }
    
    func configureCollectionViewCell(cell:CollectionViewCell, indexPath: NSIndexPath) {
        if let post = data[indexPath.item] as? InstaPost, let imageURL = post.imageURL  {
            cell.imageView.loadImageWithURL(NSURL(string: imageURL), placeholderImage: UIImage(named: kPlaceholder)!)
            if let text = post.text {
                cell.textLabel.text = text
            }
        }
    }
    
    func configureTableViewCell(cell:InstaListTableViewCell, indexPath: NSIndexPath) {
        if let post = data[indexPath.item] as? InstaPost, let imageURL = post.imageURL  {
            cell.instaImageView.loadImageWithURL(NSURL(string: imageURL), placeholderImage: UIImage(named: kPlaceholder)!)
            if let text = post.text {
                cell.instaTextLabel.text = text
            }
        }
    }
    
    func refreshCollectionView() {
        fetchOffset = data.count
        
        if fetchRequestWithOffset(fetchOffset).count == 0 {
            ServerManager.sharedManager.loadNextPageOfPosts()
        }
        
//        data = data + fetchRequestWithOffset(fetchOffset)
        
        if let collectionView = collectionView {
            var indexPathArray = [NSIndexPath]()
            for item in fetchOffset ..< data.count {
                indexPathArray.append(NSIndexPath.init(forItem: item, inSection: 0))
            }
            collectionView.insertItemsAtIndexPaths(indexPathArray)
        }
    }

    func refreshTableView() {
        fetchOffset = data.count
        print("begin count \(data.count)")
        
        if fetchRequestWithOffset(fetchOffset).count == 0 {
            ServerManager.sharedManager.loadNextPageOfPosts()
        }
        
        data = data + fetchRequestWithOffset(fetchOffset)
        
        if let tableView = tableView {
            var newIndexPathArray = [NSIndexPath]()
            for row in fetchOffset ..< data.count {
                newIndexPathArray.append(NSIndexPath.init(forRow: row, inSection: 0))
            }
            
            tableView.beginUpdates()
            tableView.insertRowsAtIndexPaths(newIndexPathArray, withRowAnimation:.Fade)
            tableView.endUpdates()

            tableView.reloadRowsAtIndexPaths(newIndexPathArray, withRowAnimation:.Fade)
        }
    
    }
}


/*
//MARK: - FetchedresultsControllerDelegate
extension InstaPostDataSource: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        blockOperations.removeAll(keepCapacity: false)
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            blockOperations.append(
                NSBlockOperation(block: { [unowned self] in
                    if let collectionView = self.collectionView, let newIndexPath = newIndexPath {
                        collectionView.insertItemsAtIndexPaths([newIndexPath])
                    }
                    if let tableView = self.tableView, let newIndexPath = newIndexPath {
                        tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation:.Fade)
                        
                    }
                    })
            )
        case .Update:
            blockOperations.append(
                NSBlockOperation(block: { [unowned self] in
                    if let collectionView = self.collectionView, let indexPath = indexPath {
                        collectionView.reloadItemsAtIndexPaths([indexPath])
                    }
                    if let tableView = self.tableView, let indexPath = indexPath {
                        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation:.Fade)
                    }
                    })
            )
        default:
            break
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        if let collectionView = collectionView {
            collectionView.performBatchUpdates({ [unowned self] in
                for operation in self.blockOperations {
                    operation.start()
                }
                }, completion: { [unowned self] finished in
                    self.blockOperations.removeAll(keepCapacity: false)
                })
        }
        
        if let tableView = tableView {
            tableView.beginUpdates()
            for operation in blockOperations {
                operation.start()
            }
            tableView.endUpdates()
            blockOperations.removeAll(keepCapacity: false)
        }
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

*/

//MARK: - UICollectionViewDataSource
extension InstaPostDataSource: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // let sectionInfo: NSFetchedResultsSectionInfo? = fetchedResultController.sections?[section]
       //  return sectionInfo?.numberOfObjects ?? 1
        
        return data.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CollectionViewCell.reuseIdentifier, forIndexPath: indexPath) as! CollectionViewCell
        configureCollectionViewCell(cell, indexPath: indexPath)
        return cell
    }
    
}

//MARK: - UITableViewDataSource
extension InstaPostDataSource: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let sectionInfo: NSFetchedResultsSectionInfo? = fetchedResultController.sections?[section]
//        return sectionInfo?.numberOfObjects ?? 1
        
        return data.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(InstaListTableViewCell.reuseIdentifier, forIndexPath: indexPath) as! InstaListTableViewCell
        configureTableViewCell(cell, indexPath: indexPath)
        return cell
    }
    
}


//MARK: - PinterestLayoutDelegate
extension InstaPostDataSource: PinterestLayoutDelegate {
    
    func collectionView(collectionView: UICollectionView, heightForCommentAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        //let post = fetchedResultController.objectAtIndexPath(indexPath) as! InstaPost
        let post =  data[indexPath.item] as! InstaPost
        
        let font = UIFont(name: kFontName, size: cFontSize)!
        let height = post.heightForComment(font, width: width)
        return height
    }
}


