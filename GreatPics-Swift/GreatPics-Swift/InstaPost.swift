//
//  InstaPost.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 11/24/15.
//  Copyright © 2015 kateryna.zaikina. All rights reserved.
//

import CoreData
import UIKit
import FastEasyMapping

class InstaPost: NSManagedObject {
    
    typealias RespondDictionary = [String: AnyObject]
    
    class func defaultMapping() -> FEMManagedObjectMapping {
        let mapping = FEMManagedObjectMapping.init(entityName: "InstaPost")
        mapping.addAttributeMappingDictionary(["identifier" : "id"])
        mapping.addAttributeMappingOfProperty("imageURL", atKeypath: "images.standard_resolution.url")
        mapping.addAttributeMappingOfProperty("text", atKeypath: "caption.text")
        
        return mapping;
    }
    
    func updateWithDictionary(responseObject: [String : AnyObject]?) {
        if let id = responseObject?["id"] as? String {
            identifier = id
        }
        if let caption = responseObject?["caption"] as? RespondDictionary, let text = caption["text"] as? String {
            
            self.text = text
        }
        
        if let images = responseObject?["images"] as? RespondDictionary, let standardResolution = images["standard_resolution"] as? RespondDictionary {
            if let url = standardResolution["url"] as? String {
                imageURL = url
            }
        }
    }
    
    func heightForComment(font: UIFont, width: CGFloat) -> CGFloat {
        if let text = text {
            let boundingSize = CGSize(width: width, height: CGFloat(MAXFLOAT))
            let rect = NSString(string: text).boundingRectWithSize(boundingSize, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
            return ceil(rect.height)
        }
        return 0
    }

}
