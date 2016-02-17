//
//  InstaListController.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 2/15/16.
//  Copyright © 2016 kateryna.zaikina. All rights reserved.
//

import UIKit
import CCBottomRefreshControl

private let cNumberOfPosts = 3
private let cEstimatedRowHeight: CGFloat = 120

class InstaListController: UITableViewController {
    
    private let serverManager = ServerManager.sharedManager
    private var dataSource: InstaPostDataSource!
    private let bottomRefresh = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = InstaPostDataSource(tableView: tableView!)
        dataSource.data = dataSource.fetchRequestWithOffset(0)
        tableView.dataSource = dataSource
        //tableView.rowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = cEstimatedRowHeight
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        bottomRefresh.triggerVerticalOffset = 100.0
        bottomRefresh.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView!.bottomRefreshControl = bottomRefresh
    }
    
    func refresh() {
        dataSource.refreshTableView()
        bottomRefresh.endRefreshing()
    }
    
    //MARK: - UITableViewDelegate
//    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        let numberOfItems = dataSource.numberOfItemsAtIndexPath(indexPath)
//        let shouldLoadNextPage: Bool = numberOfItems != nil && indexPath.item == numberOfItems! - cNumberOfPosts
//        if shouldLoadNextPage {
//          //  serverManager.loadNextPageOfPosts()
//        }
//    }

}
