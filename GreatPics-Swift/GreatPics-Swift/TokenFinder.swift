//
//  TokenFinder.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 11/23/15.
//  Copyright © 2015 kateryna.zaikina. All rights reserved.
//

import Foundation

class TokenFinder {
    
   class func accessTokenDidFind(var urlString: String) -> (String) {
    var accessToken = String()
    if urlString.rangeOfString("access_token=") != nil {
        let array = urlString.componentsSeparatedByString("#")
        if array.count > 1 {
            urlString = array[array.count - 1]
        }
        let values = urlString.componentsSeparatedByString("=")
        if values.count == 2 {
            let key = values[0]
            if key == "access_token" {
            accessToken = values[values.count - 1]
            }
        }
    }
    return accessToken
    }
    
}