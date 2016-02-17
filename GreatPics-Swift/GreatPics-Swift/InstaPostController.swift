//
//  ViewController.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 11/23/15.
//  Copyright © 2015 kateryna.zaikina. All rights reserved.
//

import UIKit
import CCBottomRefreshControl

private let cNumberOfPosts = 3
private let kShowImageSegueIdentifier = "showImage"

class InstaPostController: UICollectionViewController {

    private let serverManager = ServerManager.sharedManager
    private var dataSource: InstaPostDataSource!
    private var imageURL: String?
    private var detailInstaPost: InstaPost?
    private let refreshControl = UIRefreshControl()
    
    //MARK: - Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView!.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 10, right: 5)

        dataSource = InstaPostDataSource(collectionView: collectionView!)
        dataSource.data = dataSource.fetchRequestWithOffset(0)
        if let layout = collectionView!.collectionViewLayout as? PinterestLayout {
            layout.delegate = dataSource
        }
        
        collectionView?.dataSource = dataSource
        // serverManager.loadFirstPageOfPosts()
        
        refreshControl.triggerVerticalOffset = 100.0
        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        collectionView!.bottomRefreshControl = refreshControl
    }
    
    func refresh() {
        dataSource.refreshCollectionView()
        refreshControl.endRefreshing()
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.invalidateLayout()
        }
    }
    
    //MARK: - UICollectionViewDelegate
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //  let post = dataSource.postAtIndexPath(indexPath)
        if  dataSource.data.count > 0 {
            let post = dataSource.data[indexPath.item] as? InstaPost
            if let existPost = post {
                imageURL = existPost.imageURL
                detailInstaPost = existPost
                performSegueWithIdentifier(kShowImageSegueIdentifier, sender: self)
            }
        }
    }
//
//    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
//        let numberOfItems = dataSource.numberOfItemsAtIndexPath(indexPath)
//        let shouldLoadNextPage: Bool = numberOfItems != nil && indexPath.item == numberOfItems! - cNumberOfPosts
//        if shouldLoadNextPage {
//            serverManager.loadNextPageOfPosts()
//        }
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == kShowImageSegueIdentifier  {
            let controller =  segue.destinationViewController as! DetailImageController
            controller.instaPost = detailInstaPost
            controller.postImageURL = imageURL
        }
    }
}
