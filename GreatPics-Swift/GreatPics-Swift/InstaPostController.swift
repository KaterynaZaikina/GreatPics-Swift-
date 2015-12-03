//
//  ViewController.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 11/23/15.
//  Copyright © 2015 kateryna.zaikina. All rights reserved.
//

import UIKit

class InstaPostController: UICollectionViewController {

    private let serverManager = ServerManager.sharedManager
    private var dataSource: InstaPostDataSource!
    
    //MARK: - Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = InstaPostDataSource(collectionView: collectionView!)
        dataSource.delegate = self
        self.collectionView?.delegate = dataSource
        self.collectionView?.dataSource = dataSource
        serverManager.loadFirstPageOfPosts()
    }
    
}

//MARK: - DataSourceDelegate
extension InstaPostController: InstaPostDataSourceDelegate {
    
    func dataSourceWillDisplayLastCell(dataSource: InstaPostDataSource) {
        serverManager.loadNextPageOfPosts()
    }
    
}

