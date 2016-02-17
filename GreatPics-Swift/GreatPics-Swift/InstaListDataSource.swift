//
//  InstaListDataSource.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 2/17/16.
//  Copyright © 2016 kateryna.zaikina. All rights reserved.
//

import UIKit
import CoreData

struct DataSourceConstants {
    struct Errors {
        static let errorCode = 5555
        static let errorDomain = "com.yalantis.GreatPics.request"
        static let userInfo = "Failed to fetch request"
    }
    struct DataFetching {
        static let entityName = "InstaPost"
        static let fetchLimit = 10
    }
    struct DataEditing {
        static let fontSize: CGFloat = 14.0
        static let placeholder = "placeholder.png"
        static let fontName = "Helvetica Neue"
    }
}

//MARK: - InstaListDataSource class
final public class InstaListDataSource: NSObject {
    
    private var tableView: UITableView?
    private var fetchOffset: NSInteger = 0
    private let managedObjectContext: NSManagedObjectContext = CoreDataManager.sharedManager.managedObjectContext
    
    var data = [AnyObject]()
    
    //MARK: - init/deinit
    init(tableView: UITableView) {
        self.tableView = tableView
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
    
 
    func configureTableViewCell(cell:InstaListTableViewCell, indexPath: NSIndexPath) {
        if let post = data[indexPath.item] as? InstaPost, let imageURL = post.imageURL  {
            cell.instaImageView.loadImageWithURL(NSURL(string: imageURL), placeholderImage: UIImage(named: DataSourceConstants.DataEditing.placeholder)!)
            if let text = post.text {
                cell.instaTextLabel.text = text
            }
        }
    }
    
    func refreshTableView() {
        fetchOffset = data.count
        
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


//MARK: - UITableViewDataSource
extension InstaListDataSource: UITableViewDataSource {
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count ?? 0
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(InstaListTableViewCell.reuseIdentifier, forIndexPath: indexPath) as! InstaListTableViewCell
        configureTableViewCell(cell, indexPath: indexPath)
        return cell
    }
    
}



