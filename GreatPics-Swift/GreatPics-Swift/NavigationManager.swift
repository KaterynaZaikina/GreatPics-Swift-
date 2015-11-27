//
//  NavigationManager.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 11/23/15.
//  Copyright © 2015 kateryna.zaikina. All rights reserved.
//

import Foundation
import UIKit

class NavigationManager {

    func createdLoginController(window: UIWindow?) {
        let loginBlock = {(accessToken: String?) -> () in
            if let accessToken = accessToken {
            let serverManager = ServerManager.sharedManager
                serverManager.accessToken = accessToken
                self.createCollectionController(window)
            }
        }
        
        let loginViewController = LoginViewController.loginControllerWithCompletionBlock(loginBlock)
        let navigationController = UINavigationController(rootViewController: loginViewController)
        window?.rootViewController = navigationController
    }
    
    func createCollectionController(window: UIWindow?) {
        let sb = UIStoryboard(name:"Main", bundle:nil)
        let collectionController = sb.instantiateViewControllerWithIdentifier("InstaPostController") as! InstaPostController
        let navigationController = UINavigationController(rootViewController: collectionController)
        window?.rootViewController = navigationController
    }

}