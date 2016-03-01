//
//  DataSource.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 11/26/15.
//  Copyright © 2015 kateryna.zaikina. All rights reserved.
//

import UIKit
import CoreData

//MARK: - InstaPostDataSource class
final public class InstaPostDataSource: NSObject {
    
    private var collectionView: UICollectionView!
    private var fetchOffset: NSInteger = 0
    private let managedObjectContext: NSManagedObjectContext = CoreDataManager.sharedManager.managedObjectContext
    
    var data = [AnyObject]()
    
    //MARK: - init/deinit
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
    
    //MARK: private methods
    private func heightForComment(text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let boundingSize = CGSize(width: width, height: CGFloat(MAXFLOAT))
        let rect = NSString(string: text).boundingRectWithSize(boundingSize, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return ceil(rect.height)
    }
    
    //MARK: - public methods
    func fetchRequestWithOffset(offset: NSInteger) -> [AnyObject] {
        let fetchRequest = NSFetchRequest(entityName:DataSourceConstants.DataFetching.entityName)
        
        fetchRequest.fetchLimit = DataSourceConstants.DataFetching.fetchLimit
        fetchRequest.fetchOffset = offset
        
        let sortDescriptorKey = "createdTime"
        let sortDescriptor = NSSortDescriptor(key: sortDescriptorKey, ascending: false)
        let sortDescriptors = [sortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        
        do {
            return try managedObjectContext.executeFetchRequest(fetchRequest)
        } catch {
            var userInfo = [String: AnyObject]()
            userInfo[NSLocalizedDescriptionKey] = DataSourceConstants.Errors.userInfo
            let error = NSError(domain: DataSourceConstants.Errors.errorDomain, code: DataSourceConstants.Errors.errorCode, userInfo: userInfo)
            print("Unresolved error: \(error.userInfo)")
        }
        return []
    }
    
    func configureCollectionViewCell(cell:CollectionViewCell, indexPath: NSIndexPath) {
        if let post = data[indexPath.item] as? InstaPost, let imageURL = post.imageURL  {
            cell.imageView.loadImageWithURL(NSURL(string: imageURL), placeholderImage: UIImage(named: DataSourceConstants.DataEditing.placeholder)!)
            if let text = post.text {
                cell.textLabel.text = text
            }
        }
    }
    
    func refreshCollectionView() {
        fetchOffset = data.count
        if Reachability.isConnectedToNetwork() {
            ServerManager.sharedManager.loadPostsWithTagID(.NextPage, completionBlock:{ [unowned self] in
                self.data = self.data + self.fetchRequestWithOffset(self.fetchOffset)
                if let collectionView = self.collectionView {
                    var indexPathArray = [NSIndexPath]()
                    for item in self.fetchOffset ..< self.data.count {
                        indexPathArray.append(NSIndexPath.init(forItem: item, inSection: 0))
                    }
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        collectionView.insertItemsAtIndexPaths(indexPathArray)
                    })
                }
                })
        } else {
            data = data + fetchRequestWithOffset(self.fetchOffset)
            if let collectionView = self.collectionView {
                var indexPathArray = [NSIndexPath]()
                for item in self.fetchOffset ..< self.data.count {
                    indexPathArray.append(NSIndexPath.init(forItem: item, inSection: 0))
                }
                collectionView.insertItemsAtIndexPaths(indexPathArray)
            }
        }
    }
    
    func topRefreshCollectionView() {
        fetchOffset = 0
        ServerManager.sharedManager.loadPostsWithTagID(.FirstPage, completionBlock:{ [unowned self] in
            if let collectionView = self.collectionView {
                self.data = self.fetchRequestWithOffset(self.fetchOffset)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    collectionView.reloadData()
                })
            }
            })
    }
    
    func handleMemoryWarning() {
        let dataToDelete = data.prefixUpTo(data.count - 10)
        for post in dataToDelete {
            if let post = post as? InstaPost {
                CoreDataManager.sharedManager.managedObjectContext.deleteObject(post)
                CoreDataManager.sharedManager.saveContext()
            }
        }
        data.removeFirst(data.count - 10)
        collectionView.reloadData()
    }
}

//MARK: - UICollectionViewDataSource
extension InstaPostDataSource: UICollectionViewDataSource {
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count ?? 0
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CollectionViewCell.reuseIdentifier, forIndexPath: indexPath)
            as! CollectionViewCell
        configureCollectionViewCell(cell, indexPath: indexPath)
        return cell
    }
    
}

//MARK: - PinterestLayoutDelegate
extension InstaPostDataSource: PinterestLayoutDelegate {
    
    func collectionView(collectionView: UICollectionView, heightForCommentAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        let post =  data[indexPath.item] as! InstaPost
        let font = UIFont(name: DataSourceConstants.DataEditing.fontName, size: DataSourceConstants.DataEditing.fontSize)!
        if let text = post.text {
            let height = heightForComment(text, font: font, width: width)
            return height
        }
        return 0
    }
    
}

