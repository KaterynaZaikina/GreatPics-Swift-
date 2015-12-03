//
//  TokenFinder.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 11/23/15.
//  Copyright © 2015 kateryna.zaikina. All rights reserved.
//

import Foundation

class TokenFinder {
    
    class func findAccessToken(urlString: String) -> (String) {
        var accessToken = ""
        if urlString.rangeOfString("access_token=") != nil {
            var trimmedString: String!
            let splitedArray = urlString.characters.split("#").map{String($0)}
            
            if splitedArray.count > 1 {
                trimmedString = splitedArray[splitedArray.count - 1]
                let values = trimmedString.characters.split("=").map{String($0)}
                if values.count == 2 {
                    let key = values[0]
                    if key == "access_token" {
                        accessToken = values[values.count - 1]
                    }
                }
            }
        }
        return accessToken
    }
    
}