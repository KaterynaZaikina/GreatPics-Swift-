//
//  NavigationManager.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 11/23/15.
//  Copyright © 2015 kateryna.zaikina. All rights reserved.
//

import UIKit
import KeychainAccess

private struct Constants {
    
    static let service = "com.kateryna.GreatPics-Swift.instagram-token"
    static let accessToken = "accessToken"
    static let mainStoryboardID = "Main"
    static let InstaPostControllerID = "InstaPostController"
    static let InstaListControllerID = "InstaListController"
    
}

final public class NavigationManager {
    
    private let keychainStorage = Keychain(service: Constants.service)
    private var accessTokenExist: Bool {
        return keychainStorage[Constants.accessToken] != nil
    }

    //MARK: - Private methods
    private func createdLoginController(window: UIWindow?) {
        let loginBlock = { [unowned self] (accessToken: String?) in
            if let accessToken = accessToken {
                self.keychainStorage[Constants.accessToken] = accessToken
            }
        }
        
        let loginViewController = LoginViewController.loginControllerWithCompletionBlock(loginBlock)
        let navigationController = UINavigationController(rootViewController: loginViewController)
        window?.rootViewController = navigationController
    }

    private func createInstaPostController(window: UIWindow?) {
        if accessTokenExist == true {
            let serverManager = ServerManager.sharedManager
            serverManager.accessToken = keychainStorage[Constants.accessToken]
        }
        
        let sb = UIStoryboard(name:Constants.mainStoryboardID, bundle:nil)
        let collectionController = sb.instantiateViewControllerWithIdentifier(Constants.InstaPostControllerID) as! InstaPostController
        let navigationController = UINavigationController(rootViewController: collectionController)
        window?.rootViewController = navigationController
    }
    
    //MARK: - Public methods
    func showViewControllerInWindow(window: UIWindow) {
        if (accessTokenExist == false) {
            createdLoginController(window)
        } else {
           createInstaPostController(window)
        }
    }
    
    func showInstaListControllerInWindow(window: UIWindow) {
        let sb = UIStoryboard(name:Constants.mainStoryboardID, bundle:nil)
        let listController = sb.instantiateViewControllerWithIdentifier(Constants.InstaListControllerID) as! InstaListController
        let navigationController = window.rootViewController as! UINavigationController
        navigationController.pushViewController(listController, animated: true)
    }
    
    func showDetailViewControllerInWindow(window: UIWindow) {
        let navigationController = window.rootViewController as! UINavigationController
        let instaPostController = navigationController.topViewController as! InstaPostController
        let numberOfItems = instaPostController.collectionView!.numberOfItemsInSection(0)
        let randomNumber = random() % numberOfItems
        
        let indexPath = NSIndexPath.init(forItem: randomNumber, inSection: 0)
        instaPostController.collectionView(instaPostController.collectionView!, didSelectItemAtIndexPath: indexPath)
    }
    
}