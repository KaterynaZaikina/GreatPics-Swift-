//
//  InstagramConfig.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 11/23/15.
//  Copyright © 2015 kateryna.zaikina. All rights reserved.
//

import Foundation

private struct Constants {
    
    static let instagramAuthURL = "https://api.instagram.com/oauth/authorize/?"
    static let instagramRedirectURL = "https://yalantis.com"
    static let instagramClientSecret = "5d245e1de66a4f75a4779468c03a8f8d"
    static let instagramClientID  = "ffce67cce0814cb996eef468646cf08f"
    static var loginURL = Constants.instagramAuthURL + "client_id=" + Constants.instagramClientID + "&redirect_uri=" + Constants.instagramRedirectURL + "&response_type=token"
    
}


final public class InstagramConfig {
    
    //MARK: - Class methods
    class func findAccessToken(urlString: String) -> String {
        var accessToken = ""
        if urlString.rangeOfString("access_token=") != nil {
            let splitedArray = urlString.characters.split("#").map{String($0)}
            if splitedArray.count > 1 {
                let trimmedString = splitedArray[splitedArray.count - 1]
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
    
    class func loginURLString() -> String {
        return Constants.loginURL
    }
    
}