//
//  NetworkingOperation.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 12/1/15.
//  Copyright © 2015 kateryna.zaikina. All rights reserved.
//

import Foundation

class NetworkingOperation: NSOperation {

    typealias OperationCompletion = (NSData?, NSURLResponse?, NSError?) -> ()
    
    var completionHandler: OperationCompletion?
    var queue: dispatch_queue_t?
    private let requestURL: NSURL?
    private var _isFinished = false
    override var finished: Bool {
        get {
            return _isFinished
        }
    }
    
    override func cancel() {
        super.cancel()
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
        guard let requestURL = requestURL else {
            return
        }
            NSURLSession.sharedSession().dataTaskWithURL(requestURL, completionHandler: { [weak self] data, response, error in
                guard let weakSelf = self else { return }
                if let queue = weakSelf.queue {
                   dispatch_async(queue, {
                    weakSelf.completionHandler?(data, response, error)
                    weakSelf.willChangeValueForKey("isFinished")
                    weakSelf._isFinished = true
                    weakSelf.didChangeValueForKey("isFinished")
                   })
                }
            }).resume()
            
        self.willChangeValueForKey("isFinished")
        _isFinished = true
        self.didChangeValueForKey("isFinished")
        }
    
}
