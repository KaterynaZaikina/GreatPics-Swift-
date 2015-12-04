//
//  InstaPostSeque.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 12/4/15.
//  Copyright © 2015 kateryna.zaikina. All rights reserved.
//

import Foundation
import UIKit


class InstaPostSegue: UIStoryboardSegue {
    
    override func perform() {
        sourceViewController.showViewController(destinationViewController, sender:sourceViewController)
    }
}