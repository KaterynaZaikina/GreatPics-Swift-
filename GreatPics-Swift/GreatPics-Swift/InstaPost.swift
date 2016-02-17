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

private struct Constants {
    
    static let id = "id"
    static let imageResolution = "standard_resolution"
    static let images = "images"
    static let caption = "caption"
    static let text = "text"
    static let url = "url"
    
}

final public class InstaPost: NSManagedObject {
    
    typealias RespondDictionary = [String: AnyObject]
    
    //MARK: public methods
    func updateWithDictionary(responseObject: [String : AnyObject]?) {
        if let id = responseObject?[Constants.id] as? String {
            identifier = id
        }
        if let caption = responseObject?[Constants.caption] as? RespondDictionary, let text = caption[Constants.text] as? String {
            self.text = text
        }
        if let images = responseObject?[Constants.images] as? RespondDictionary, let standardResolution = images[Constants.imageResolution] as? RespondDictionary {
            if let url = standardResolution[Constants.url] as? String {
                imageURL = url
            }
        }
    }
    
}
