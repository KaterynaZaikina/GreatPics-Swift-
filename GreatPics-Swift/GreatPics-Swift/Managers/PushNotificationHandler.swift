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
    
}

class PushNotificationHandler {
    
    func registerForNotifications(application: UIApplication) {
        let actionList = UIMutableUserNotificationAction()
        actionList.activationMode = .Foreground
        actionList.title = Constants.actionListIdentifier
        actionList.identifier = Constants.actionListIdentifier
        
        let actionGrid = UIMutableUserNotificationAction()
        actionGrid.activationMode = .Foreground
        actionGrid.title = Constants.actionGridIdentifier
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
        if identifier == Constants.actionListIdentifier {
            NavigationManager().showInstaListControllerInWindow(application.keyWindow!)
        }
    }
    
    func handleRemoteNotification(application: UIApplication) {
         NavigationManager().showDetailViewControllerInWindow(application.keyWindow!)
    }
    
}
