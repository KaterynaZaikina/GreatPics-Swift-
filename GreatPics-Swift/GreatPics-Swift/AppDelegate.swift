//
//  AppDelegate.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 11/23/15.
//  Copyright © 2015 kateryna.zaikina. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let loginViewController = LoginViewController.loginControllerWithCompletionBlock { _ in
        }
        
        let navigationController = UINavigationController(rootViewController: loginViewController)
        window!.rootViewController = navigationController
        window!.makeKeyAndVisible()
        return true
    }

}

