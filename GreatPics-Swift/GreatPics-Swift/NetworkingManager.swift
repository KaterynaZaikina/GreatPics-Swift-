//
//  NetworkingManager.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 11/27/15.
//  Copyright © 2015 kateryna.zaikina. All rights reserved.
//


import Foundation

enum NetworkingError: ErrorType {
    case InvalidURLRequest
}

class NetworkingManager {
    
    var baseURL: String
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    func sendGETRequest(urlString: String?, parameters:[String : AnyObject]?, success: ([String : AnyObject]? -> Void)?, failure:(NSError -> Void)?) throws {
        
        var completeURLString = baseURL
        
        if let urlString = urlString  {
            completeURLString = baseURL + "\(urlString)"
            if let parameters = parameters {
                completeURLString = completeURLString + "?" + stringFromHttpParameters(parameters)
            }
        }
        
        var request: NSURLRequest?
        
        let requestURL = NSURL(string: completeURLString)
        if let requestURL = requestURL {
            request = NSURLRequest(URL: requestURL)
        }
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        guard request != nil else {
            throw NetworkingError.InvalidURLRequest
        }
        
        let task = session.dataTaskWithRequest(request!, completionHandler: { data, response, error -> Void in
            
            var json: [String : AnyObject]?
            if let data = data {
                do {
                    json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? [String : AnyObject]
                } catch {
                    print("error with data")
                }
            }
            
            success?(json)
            if json == nil {
                print("JSON is not recieved!")
            }
            
            if let acceptedError = error {
                failure?(acceptedError)
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




