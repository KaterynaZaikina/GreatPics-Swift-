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

final public class NetworkingManager {
    
    private var baseURL: String?
    private let operationManager = NetworkOperationManager()
    
    
    //MARK: - init/deinit
    init(baseURL: String?) {
        self.baseURL = baseURL
    }
    
    // MARK: - Public methods
    func sendGETRequest(urlString: String?, parameters:[String : AnyObject]?, success: ([String : AnyObject]? -> Void)?, failure:(NSError -> Void)?) throws {
        
        guard let baseURL = self.baseURL else {
            return
        }
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
        
        guard request != nil else {
            throw NetworkingError.InvalidURLRequest
        }
        let networkOperation = NetworkingOperation(requestURL: requestURL)
        
        networkOperation.queue = dispatch_get_main_queue()
        networkOperation.queuePriority = .High
        
        networkOperation.completionHandler = { (data, response, error) in
            guard let data = data where error == nil else {
                print(error)
                return
            }
            
            var json: [String : AnyObject]?
            do {
                json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [String : AnyObject]
            } catch {
                print("error with data")
            }
            
            success?(json)
            if json == nil {
                print("JSON is not recieved!")
            }
            
            if let acceptedError = error {
                failure?(acceptedError)
            }
        }
        
        let key = requestURL!.absoluteString
        operationManager.addNewOperation(networkOperation, key: key)
    }
    
    // MARK: - String and Dictionary extensions
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