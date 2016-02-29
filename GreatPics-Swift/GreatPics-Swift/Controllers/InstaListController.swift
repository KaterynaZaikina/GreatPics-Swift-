//
//  InstaListController.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 2/15/16.
//  Copyright © 2016 kateryna.zaikina. All rights reserved.
//

import UIKit
import CCBottomRefreshControl

private struct Constants {
    
    static let showImageSegueIdentifier = "showImageFromListVC"
    static let estimatedRowHeight: CGFloat = 120.0
    static let triggerVerticalOffset: CGFloat = 100.0
    
}

final public class InstaListController: UITableViewController {
    
    private let serverManager = ServerManager.sharedManager
    private let bottomRefresh = UIRefreshControl()
    private var dataSource: InstaListDataSource!
    private var detailInstaPost: InstaPost?

    //MARK: - Controller lifecycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = InstaListDataSource(tableView: tableView!)
        dataSource.data = dataSource.fetchRequestWithOffset(0)
        tableView.dataSource = dataSource
    
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = Constants.estimatedRowHeight
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        bottomRefresh.triggerVerticalOffset = Constants.triggerVerticalOffset
        bottomRefresh.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView!.bottomRefreshControl = bottomRefresh
    }
    
    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.showImageSegueIdentifier  {
            let controller =  segue.destinationViewController as! DetailImageController
            controller.instaPost = detailInstaPost
            controller.postImageURL = detailInstaPost?.imageURL
        }
    }
    
    override public func didReceiveMemoryWarning() {
        dataSource.handleMemoryWarning()
    }
    
    //MARK: - Public methods
    func refresh() {
        dataSource.refreshTableView()
        bottomRefresh.endRefreshing()
    }
    
    //MARK: - UITableViewDelegate
    override public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if  dataSource.data.count > 0 {
            let post = dataSource.data[indexPath.item] as? InstaPost
            if let existPost = post {
                detailInstaPost = existPost
                                performSegueWithIdentifier(Constants.showImageSegueIdentifier, sender: self)
            }
        }
    }

    
}
