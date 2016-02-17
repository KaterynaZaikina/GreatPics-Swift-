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
    
    //MARK: - public methods
    func fetchRequestWithOffset(offset: NSInteger) -> [AnyObject] {
        let fetchRequest = NSFetchRequest(entityName:DataSourceConstants.DataFetching.entityName)
        
        fetchRequest.fetchBatchSize = DataSourceConstants.DataFetching.fetchLimit
        fetchRequest.fetchLimit = DataSourceConstants.DataFetching.fetchLimit
        fetchRequest.fetchOffset = offset
        
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
        
        if fetchRequestWithOffset(fetchOffset).count == 0 {
            ServerManager.sharedManager.loadNextPageOfPosts()
        }
        
        data = data + fetchRequestWithOffset(fetchOffset)
        
        if let collectionView = collectionView {
            var indexPathArray = [NSIndexPath]()
            for item in fetchOffset ..< data.count {
                indexPathArray.append(NSIndexPath.init(forItem: item, inSection: 0))
            }
            collectionView.insertItemsAtIndexPaths(indexPathArray)
        }
    }
    
    //MARK: helper methods
    func heightForComment(text: String, font: UIFont, width: CGFloat) -> CGFloat {
            let boundingSize = CGSize(width: width, height: CGFloat(MAXFLOAT))
            let rect = NSString(string: text).boundingRectWithSize(boundingSize, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
            return ceil(rect.height)
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


