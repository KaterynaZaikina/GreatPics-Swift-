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
    typealias R = [String : AnyObject]
    
    func updateWithDictionary(responseObject: [String : AnyObject]?) {
        if let id = responseObject?["id"] as? String {
            identifier = id
        }
        if let caption = responseObject?["caption"] as? R,  let text = caption["text"] as? String {
            self.text = text
        }
        if let images = responseObject?["images"] as? R, let standard_resolution = images["standard_resolution"] as? R {
            if let url = standard_resolution["url"] as? String {
                imageURL = url
            }
        }
    }
    
    func heightForComment(font: UIFont, width: CGFloat) -> CGFloat {
        if let text = text {
        let rect = NSString(string: text).boundingRectWithSize(CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return ceil(rect.height)
        }
        return 0
    }
    
}
