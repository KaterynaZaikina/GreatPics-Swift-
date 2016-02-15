//
//  InstaListController.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 2/15/16.
//  Copyright © 2016 kateryna.zaikina. All rights reserved.
//

import UIKit

private let numberOfPosts = 3

class InstaListController: UITableViewController {
    
    private let serverManager = ServerManager.sharedManager
    private var dataSource: InstaPostDataSource!

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = InstaPostDataSource(tableView: tableView!)
        tableView.dataSource = dataSource
        
    }

    //MARK: - UITableViewDelegate
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let numberOfItems = dataSource.numberOfItemsAtIndexPath(indexPath)
        let shouldLoadNextPage: Bool = numberOfItems != nil && indexPath.item == numberOfItems! - numberOfPosts
        if shouldLoadNextPage {
            serverManager.loadNextPageOfPosts()
        }
    }
    
}
