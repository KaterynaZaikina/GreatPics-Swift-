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
    
    func sendGETRequest(urlString: String?, parameters:[String : AnyObject]?, success: ([String : AnyObject]? -> Void)?, failure:(NSError -> Void)?) {
        
        var parameterString: String?
        if parameters != nil {
            parameterString = parameters!.stringFromHttpParameters()
        }
        
        var completeURLString: String?
        if urlString != nil && parameterString != nil {
            completeURLString = "\(urlString!)?\(parameterString!)"
        }
        
        var request: NSURLRequest?
        if completeURLString != nil {
            request = NSURLRequest(URL: NSURL(string: completeURLString!)!)
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
                let userInfo = [NSLocalizedDescriptionKey : "Response Object is not recieved"]
                let error = NSError(domain:errorDomain, code:errorCode, userInfo: userInfo)
                print("error - \(error.localizedDescription), status code - \(error.code)") }
            
        })
        
        task.resume()
        
    }
}
