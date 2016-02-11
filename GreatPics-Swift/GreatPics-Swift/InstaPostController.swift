//
//  ViewController.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 11/23/15.
//  Copyright © 2015 kateryna.zaikina. All rights reserved.
//

import UIKit

private let numberOfPosts = 3

class InstaPostController: UICollectionViewController {

    private let serverManager = ServerManager.sharedManager
    private var dataSource: InstaPostDataSource!
    private var imageURL: String?
       
    //MARK: - Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = InstaPostDataSource(collectionView: collectionView!)
        collectionView?.delegate = self
        collectionView?.dataSource = dataSource
        serverManager.loadFirstPageOfPosts()
    }
    
    //MARK: - UICollectionViewDelegate
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let post = dataSource.postAtIndexPath(indexPath)
        if let existPost = post {
            imageURL = existPost.imageURL
            performSegueWithIdentifier("showImage", sender: self)
        }
    }
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let numberOfItems = dataSource.numberOfItemsAtIndexPath(indexPath)
        if numberOfItems != nil && indexPath.item == numberOfItems! - numberOfPosts {
            serverManager.loadNextPageOfPosts()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showImage"  {
            let controller =  segue.destinationViewController as! DetailImageController
            controller.postImageURL = imageURL
        }
    }
    
}

extension InstaPostController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
            return dataSource.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAtIndexPath: indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
    return 5
    }
    
}


