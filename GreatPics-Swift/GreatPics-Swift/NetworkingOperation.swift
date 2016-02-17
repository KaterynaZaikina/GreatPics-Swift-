//
//  NetworkingOperation.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 12/1/15.
//  Copyright © 2015 kateryna.zaikina. All rights reserved.
//

import Foundation

final public class NetworkingOperation: NSOperation {

    typealias OperationCompletion = (NSData?, NSURLResponse?, NSError?) -> ()
    
    private let requestURL: NSURL?
    private var _isFinished = false
    
    var completionHandler: OperationCompletion?
    var queue: dispatch_queue_t?

    //MARK: Override public methods
    override public var finished: Bool {
        get {
            return _isFinished
        }
    }
    
    override public func cancel() {
        super.cancel()
    }
    
    override public var executing: Bool {
        get {
            return !_isFinished
        }
    }
    
    override public var asynchronous: Bool {
        get {
            return true
        }
    }
    
    init(requestURL: NSURL?) {
       self.requestURL = requestURL
    }
    
    override public func main() {
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
