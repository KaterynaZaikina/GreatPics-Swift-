//
//  TokenFinder.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 11/23/15.
//  Copyright © 2015 kateryna.zaikina. All rights reserved.
//

import Foundation

class TokenFinder {
//Review: Текст не отформатирован выдели весь текст и нажми ctrl + i
    
   class func accessTokenDidFind(var urlString: String) -> (String) {
    var accessToken = String()
    if urlString.rangeOfString("access_token=") != nil {
//Review: прочитай про команду split в свифте let splitedArray = urlString.characters.split("#").map{String($0)}
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