//
//  NetworkingOperation.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 12/1/15.
//  Copyright © 2015 kateryna.zaikina. All rights reserved.
//

import Foundation

class NetworkingOperation: NSOperation {

    typealias OperationCompletion = (NSData?, NSURLResponse?, NSError?) -> Void
    var completionHandler: OperationCompletion?
    let requestURL: NSURL?
    var queue: dispatch_queue_t?
    private var _isFinished = false
    override var finished: Bool {
        get {
            return _isFinished
        }
    }
    
    override var executing: Bool {
        get {
            return !_isFinished
        }
    }
    
    override var asynchronous: Bool {
        get {
            return true
        }
    }
    
    init(requestURL: NSURL?) {
       self.requestURL = requestURL
    }
    
    override func main() {
        if let requestURL = requestURL {
            NSURLSession.sharedSession().dataTaskWithURL(requestURL, completionHandler: { (data, response, error) -> Void in
                if let queue = self.queue {
                   dispatch_async(queue, { () -> Void in
                    self.completionHandler?(data, response, error)
                    
                    self.willChangeValueForKey("isFinished")
                    self._isFinished = true
                    self.didChangeValueForKey("isFinished")
                   })
                }
              
            }).resume()
            
        self.willChangeValueForKey("isFinished")
        _isFinished = true
        self.didChangeValueForKey("isFinished")
        }
    }
    
    
}
