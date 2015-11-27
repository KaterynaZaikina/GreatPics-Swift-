//
//  ViewController.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 11/23/15.
//  Copyright © 2015 kateryna.zaikina. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {
        
    private let dataSource = InstaPostDataSource()
    private let serverManager = ServerManager.sharedManager

    //MARK: - Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.delegate = self
        self.collectionView?.delegate = dataSource
        self.collectionView?.dataSource = dataSource
        serverManager.loadFirstPageOfPosts()
    }

}

    //MARK: - DataSourceDelegate
extension CollectionViewController: InstaPostDataSourceDelegate {
    
    func dataSourceWillDisplayLastCell(dataSource: InstaPostDataSource) {
        serverManager.loadNextPageOfPosts()
    }
    
    func dataSourceDidChangeContent(dataSource: InstaPostDataSource) {
        self.collectionView?.reloadData()
    }
    
}

