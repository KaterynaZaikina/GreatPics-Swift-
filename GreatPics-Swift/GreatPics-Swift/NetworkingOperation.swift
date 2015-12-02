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

        if let requestURL = requestURL {
            NSURLSession.sharedSession().dataTaskWithURL(requestURL, completionHandler: { [weak self] data, response, error in
                guard let this = self else { return }
                if let queue = this.queue {
                   dispatch_async(queue, { () -> Void in
                    this.completionHandler?(data, response, error)
                    this.willChangeValueForKey("isFinished")
                    this._isFinished = true
                    this.didChangeValueForKey("isFinished")
                   })
                }
            }).resume()
            
        self.willChangeValueForKey("isFinished")
        _isFinished = true
        self.didChangeValueForKey("isFinished")
        }
    }
    
}
