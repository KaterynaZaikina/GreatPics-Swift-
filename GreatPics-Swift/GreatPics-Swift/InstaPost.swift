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
    
    func updateWithDictionary(responseObject: [String : AnyObject]?) {
        if let id = responseObject?["id"] as? String {
            identifier = id
        }
        if let caption = responseObject?["caption"] as? [String : AnyObject],  let text = caption["text"] as? String {
            self.text = text
        }
        if let images = responseObject?["images"] as? [String: AnyObject] {
            if let standard_resolution = images["standard_resolution"] as? [String: AnyObject] {
                if let url = standard_resolution["url"] as? String {
                    imageURL = url
                }
            }
        }
    }
    
    
}
