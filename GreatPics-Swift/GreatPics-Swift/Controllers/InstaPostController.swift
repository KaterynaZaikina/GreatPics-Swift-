//
//  ViewController.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 11/23/15.
//  Copyright © 2015 kateryna.zaikina. All rights reserved.
//

import UIKit
import CCBottomRefreshControl

private struct Constants {
    
    static let showImageSegueIdentifier = "showImageFromPostVC"
    static let triggerVerticalOffset: CGFloat = 100.0
    static let insets: CGFloat = 5.0
    
}

final public class InstaPostController: UICollectionViewController {

    private let serverManager = ServerManager.sharedManager
    private let bottomRefreshControl = UIRefreshControl()
    private let topRefreshControl = UIRefreshControl()
    
    private var dataSource: InstaPostDataSource!
    private var detailInstaPost: InstaPost?
    
    //MARK: - Controller lifecycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        collectionView!.contentInset = UIEdgeInsets(top: Constants.insets, left: Constants.insets,
                                                 bottom: Constants.insets, right: Constants.insets)

        dataSource = InstaPostDataSource(collectionView: collectionView!)
        collectionView?.dataSource = dataSource
        dataSource.refreshCollectionView()
        
        if let layout = collectionView!.collectionViewLayout as? PinterestLayout {
            layout.delegate = dataSource
        }
        
        bottomRefreshControl.triggerVerticalOffset = Constants.triggerVerticalOffset
        bottomRefreshControl.addTarget(self, action: "refresh", forControlEvents: .ValueChanged)
        collectionView!.bottomRefreshControl = bottomRefreshControl
        
        
        topRefreshControl.addTarget(self, action: "topRefresh", forControlEvents: .ValueChanged)
        collectionView!.addSubview(topRefreshControl)
        
        
    }
    
    //MARK: - Public methods
    func refresh() {
        dataSource.refreshCollectionView()
        bottomRefreshControl.endRefreshing()
    }
    
    func topRefresh() {
        dataSource.topRefreshCollectionView()
        topRefreshControl.endRefreshing()
    }
    
    public override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.invalidateLayout()
        }
    }
    
    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.showImageSegueIdentifier  {
            let controller =  segue.destinationViewController as! DetailImageController
            controller.instaPost = detailInstaPost
            controller.postImageURL = detailInstaPost?.imageURL
        }
    }
    
    //MARK: - UICollectionViewDelegate
    override public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
            if  dataSource.data.count > 0 {
            let post = dataSource.data[indexPath.item] as? InstaPost
            if let existPost = post {
                detailInstaPost = existPost
                performSegueWithIdentifier(Constants.showImageSegueIdentifier, sender: self)
            }
        }
    }
    
}
