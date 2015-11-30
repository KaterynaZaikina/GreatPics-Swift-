//
//  NetworkingManager.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 11/27/15.
//  Copyright © 2015 kateryna.zaikina. All rights reserved.
//

private let errorDomain = "com.yalantis.GreatPics.instagram"
private let errorCode = 333

import Foundation

class NetworkingManager {
    
    var baseURL: String?
    
    init(baseURL: String?) {
    self.baseURL = baseURL
    }
    
    func sendGETRequest(urlString: String?, parameters:[String : AnyObject]?, success: ([String : AnyObject]? -> Void)?, failure:(NSError -> Void)?) {
        
        guard let parameters = parameters else {
            return
        }
        
        let parameterString = stringFromHttpParameters(parameters)
        
        var completeString: String?
        if let urlString = urlString, baseURL = baseURL {
            completeString = baseURL + "\(urlString)?\(parameterString)"
        }
        
        var request: NSURLRequest?
        guard let completeURLString = completeString else {
            return
        }
        
        let requestURL = NSURL(string: completeURLString)
        if let requestURL = requestURL {
            request = NSURLRequest(URL: requestURL)
        }
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        guard request != nil else {
            return
        }
        
        let task = session.dataTaskWithRequest(request!, completionHandler: { data, response, error -> Void in
            
            var json: [String : AnyObject]?
            if let data = data {
                do {
                    json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? [String : AnyObject]
                    print("\(json)")
                } catch {
                    print("error with data")
                }
            }
            
            if let json = json  {
                success?(json)
            } else {
                success?(nil)
                let userInfo = [NSLocalizedDescriptionKey : "Response Object is not recieved"]
                let error = NSError(domain:errorDomain, code:errorCode, userInfo: userInfo)
                print("error - \(error.localizedDescription), status code - \(error.code)") }
            
            if let errorAccepted = error {
                failure?(errorAccepted)
            }
        })
        task.resume()
    }
    
    private func stringByAddingPercentEncodingForURLQueryValue(string: String) -> String {
        let characterSet = NSMutableCharacterSet.alphanumericCharacterSet()
        characterSet.addCharactersInString("-._~")
        
        return string.stringByAddingPercentEncodingWithAllowedCharacters(characterSet)!
    }
    
    private func stringFromHttpParameters(dictionary: [String : AnyObject]) -> String {
        let parameterArray = dictionary.map { (key, value) -> String in
            let percentEscapedKey = stringByAddingPercentEncodingForURLQueryValue(key)
            let percentEscapedValue = stringByAddingPercentEncodingForURLQueryValue((value as! String))
            return "\(percentEscapedKey)=\(percentEscapedValue)"
        }
        return parameterArray.joinWithSeparator("&")
    }
    
}




