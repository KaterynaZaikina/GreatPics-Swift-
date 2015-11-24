//
//  InstaPost.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 11/24/15.
//  Copyright © 2015 kateryna.zaikina. All rights reserved.
//

import Foundation
import CoreData

class InstaPost: NSManagedObject {
    
    func updateWithDictionary(responseObject: [String : String]?) {
        identifier = responseObject?["id"]
        text = responseObject?["caption.text"]
        imageURL = responseObject?["images.standard_resolution.url"]
    }
    
}
