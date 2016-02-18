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
    static let InstaPostcontrollerID = "InstaPostController"
    
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
//MARK: Code_Review_18.02.2016: Naming
    private func createCollectionController(window: UIWindow?) {
        if accessTokenExist == true {
            let serverManager = ServerManager.sharedManager
            serverManager.accessToken = keychainStorage[Constants.accessToken]
        }
        
        let sb = UIStoryboard(name:Constants.mainStoryboardID, bundle:nil)
        let collectionController = sb.instantiateViewControllerWithIdentifier(Constants.InstaPostcontrollerID) as! InstaPostController
        let navigationController = UINavigationController(rootViewController: collectionController)
        window?.rootViewController = navigationController
    }
    
    //MARK: - Public methods
//MARK: Code_Review_18.02.2016: Naming
    func showMainScreen(window: UIWindow) {
        if (accessTokenExist == false) {
            createdLoginController(window)
        } else {
           createCollectionController(window)
        }
    }
    
}