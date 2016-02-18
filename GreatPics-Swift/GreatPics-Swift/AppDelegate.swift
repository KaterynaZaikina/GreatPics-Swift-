//
//  AppDelegate.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 11/23/15.
//  Copyright © 2015 kateryna.zaikina. All rights reserved.
//

import UIKit
import KeychainAccess

//MARK: Code_Review_18.02.2016: File structure

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private let navigationManager = NavigationManager()
        
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        navigationManager.showMainScreen(window!)
        window!.makeKeyAndVisible()
        return true
    }

}

