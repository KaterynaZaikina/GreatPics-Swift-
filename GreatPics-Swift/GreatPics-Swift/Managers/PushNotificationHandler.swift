//
//  PushNotificationHandler.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 2/22/16.
//  Copyright © 2016 kateryna.zaikina. All rights reserved.
//

import UIKit

private struct Constants {
    
    static let pushToken = "0b116b05 dc1ff3ea b1b1f427 a6605f9a 65828e3a 5dc3a15a 5d52bd01 0f8ff6b0"
    static let actionListIdentifier = "Show List"
    static let actionGridIdentifier = "Show Grid"
    static let categoryIdentifier = "Actionable"
    static let contentavailableInfoKey = "content-available"
    static let apsInfoKey = "aps"
}

class PushNotificationHandler {
    
    private let navigationManager = NavigationManager()
    
    func registerForNotifications(application: UIApplication) {
        let actionList = UIMutableUserNotificationAction()
        actionList.activationMode = .Foreground
        actionList.title = NSLocalizedString(Constants.actionListIdentifier, comment: "")
        actionList.identifier = Constants.actionListIdentifier
        
        let actionGrid = UIMutableUserNotificationAction()
        actionGrid.activationMode = .Foreground
        actionGrid.title = NSLocalizedString(Constants.actionGridIdentifier, comment: "")
        actionGrid.identifier = Constants.actionGridIdentifier
        
        
        let actionCategory = UIMutableUserNotificationCategory()
        actionCategory.identifier = Constants.categoryIdentifier
        actionCategory.setActions([actionList, actionGrid], forContext: .Default)
        
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories:[actionCategory]))
        application.registerForRemoteNotifications()
        
    }
    
    func handleBadgeNumber(aplication: UIApplication) {
        var value = aplication.applicationIconBadgeNumber
        value = value - 1
        aplication.applicationIconBadgeNumber = value
    }
    
    func handleActionInApplication(application: UIApplication, identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        if application.applicationState != .Active {
            if identifier == Constants.actionListIdentifier {
                navigationManager.showInstaListControllerInWindow(application.keyWindow!)
            } else {
                navigationManager.showInstaPostControllerInWindow(application.keyWindow!)
            }
            completionHandler()
        }
    }
    
    func handleRemoteNotification(application: UIApplication, userInfo: [NSObject : AnyObject], completionHandler: (UIBackgroundFetchResult) -> Void) {
        if application.applicationState != .Active {
            if let check = userInfo[Constants.apsInfoKey] as? [String: AnyObject] where check[Constants.contentavailableInfoKey] != nil {
                handleSilentPushNotification(application, userInfo: userInfo, fetchCompletionHandler: completionHandler)
            } else {
                navigationManager.showDetailViewControllerInWindow(application.keyWindow!)
                completionHandler(.NoData)
            }
        }
    }
    
    func handleSilentPushNotification(application: UIApplication, userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        let navigationController = application.keyWindow!.rootViewController as! UINavigationController
        let instaPostController = navigationController.topViewController as! InstaPostController
        instaPostController.topRefresh()
        completionHandler(.NewData)
    }
    
}
