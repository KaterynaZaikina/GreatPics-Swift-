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

    private let navigationManager = NavigationManager()
    private let notificationHandler = PushNotificationHandler()
        
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        navigationManager.showViewControllerInWindow(window!)
        window!.makeKeyAndVisible()
        
        notificationHandler.registerForNotifications(application)
        
        return true
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        notificationHandler.handleBadgeNumber(application)
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        print("device token - \(deviceToken)")
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Failed to get token, \(error)")
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        notificationHandler.handleActionInApplication(application, identifier: identifier, forRemoteNotification: userInfo, completionHandler:completionHandler)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        notificationHandler.handleRemoteNotification(application)
    
    }
        
}

