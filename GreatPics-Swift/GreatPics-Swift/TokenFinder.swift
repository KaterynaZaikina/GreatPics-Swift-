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
            let splitedArray = urlString.characters.split("#").map{String($0)}
            
            if splitedArray.count > 1 {
                urlString = splitedArray[splitedArray.count - 1]
            }
            let values = urlString.characters.split("=").map{String($0)}
            if values.count == 2 {
                let key = values[0]
                if key == "access_token" {
                    accessToken = values[values.count - 1]
                }
            }
        }
        print(accessToken)
        return accessToken
    }
    
}