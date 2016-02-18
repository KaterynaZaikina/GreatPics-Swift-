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
    
    static let showImageSegueIdentifier = "showImage"
    static let triggerVerticalOffset: CGFloat = 100.0
    static let insets: CGFloat = 5.0
    
}

final public class InstaPostController: UICollectionViewController {

    private let serverManager = ServerManager.sharedManager
    private let refreshControl = UIRefreshControl()
    
    private var dataSource: InstaPostDataSource!
    private var imageURL: String?
    private var detailInstaPost: InstaPost?
    
    //MARK: - Controller lifecycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        collectionView!.contentInset = UIEdgeInsets(top: Constants.insets, left: Constants.insets,
                                                 bottom: Constants.insets, right: Constants.insets)

        dataSource = InstaPostDataSource(collectionView: collectionView!)
        
        if dataSource.fetchRequestWithOffset(0).count == 0 {
            serverManager.loadFirstPageOfPosts()
        }
        
        if let layout = collectionView!.collectionViewLayout as? PinterestLayout {
            layout.delegate = dataSource
        }
        
        collectionView?.dataSource = dataSource
        
        refreshControl.triggerVerticalOffset = Constants.triggerVerticalOffset
        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        collectionView!.bottomRefreshControl = refreshControl
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        dataSource.data = dataSource.fetchRequestWithOffset(0) 
    }
    
    //MARK: - Public methods
    func refresh() {
        dataSource.refreshCollectionView()
        refreshControl.endRefreshing()
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
            controller.postImageURL = imageURL
        }
    }
    
    //MARK: - UICollectionViewDelegate
    override public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
            if  dataSource.data.count > 0 {
            let post = dataSource.data[indexPath.item] as? InstaPost
            if let existPost = post {
                imageURL = existPost.imageURL
                detailInstaPost = existPost
                performSegueWithIdentifier(Constants.showImageSegueIdentifier, sender: self)
            }
        }
    }
    
}
