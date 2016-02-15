//
//  InstaPost.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 11/24/15.
//  Copyright © 2015 kateryna.zaikina. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class InstaPost: NSManagedObject {
    
    typealias RespondDictionary = [String: AnyObject]
    
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
