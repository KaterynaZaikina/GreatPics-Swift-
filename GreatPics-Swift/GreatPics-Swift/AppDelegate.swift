//
//  AppDelegate.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 11/23/15.
//  Copyright © 2015 kateryna.zaikina. All rights reserved.
//

import UIKit
import KeychainAccess

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let navigationManager: NavigationManager = NavigationManager()
        
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        if (navigationManager.accessTokenExist == false) {
            navigationManager.createdLoginController(window)
        } else {
            navigationManager.createCollectionController(window)
        }
        
        window!.makeKeyAndVisible()
        return true
    }

}

