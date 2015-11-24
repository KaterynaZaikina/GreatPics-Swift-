//
//  InstaPost+CoreDataProperties.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 11/24/15.
//  Copyright © 2015 kateryna.zaikina. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension InstaPost {

    @NSManaged var createdAtDate: NSDate?
    @NSManaged var identifier: String?
    @NSManaged var imageURL: String?
    @NSManaged var text: String?

}
