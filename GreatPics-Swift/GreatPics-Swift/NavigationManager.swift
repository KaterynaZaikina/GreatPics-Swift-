//
//  NavigationManager.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 11/23/15.
//  Copyright © 2015 kateryna.zaikina. All rights reserved.
//

import Foundation
import UIKit
import KeychainAccess

class NavigationManager {
    
    private let keychainStorage: Keychain = Keychain(service: "com.kateryna.GreatPics-Swift.instagram-token")
    private var accessTokenExist: Bool {
        if keychainStorage["accessToken"] != nil {
            return true
        } else {
            return false
        }
    }

    func createdLoginController(window: UIWindow?) {
        let loginBlock = { [unowned self] (accessToken: String?) in
            if let accessToken = accessToken {
                self.keychainStorage["accessToken"] = accessToken
            }
        }
        
        let loginViewController = LoginViewController.loginControllerWithCompletionBlock(loginBlock)
        let navigationController = UINavigationController(rootViewController: loginViewController)
        window?.rootViewController = navigationController
    }
    
    func createCollectionController(window: UIWindow?) {
        if accessTokenExist == true {
            let serverManager = ServerManager.sharedManager
            serverManager.accessToken = keychainStorage["accessToken"]
        }
        
        let sb = UIStoryboard(name:"Main", bundle:nil)
        let collectionController = sb.instantiateViewControllerWithIdentifier("InstaPostController") as! InstaPostController
        let navigationController = UINavigationController(rootViewController: collectionController)
        window?.rootViewController = navigationController
    }
    
    func showMainScreen(window: UIWindow) {
        if (accessTokenExist == false) {
            createdLoginController(window)
        } else {
           createCollectionController(window)
        }
    }
    
}