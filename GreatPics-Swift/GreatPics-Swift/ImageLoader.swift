//
//  ImageLoader.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 12/3/15.
//  Copyright © 2015 kateryna.zaikina. All rights reserved.
//

import UIKit

class ImageLoader {
    
    private let operationManager = NetworkOperationManager()
    static let sharedLoader = ImageLoader()
    
    func loadImageWithURL(imageURL: NSURL, completionBlock: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSOperation {
        let networkOperation = NetworkingOperation(requestURL: imageURL)
        networkOperation.queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        networkOperation.queuePriority = .Normal
        
        networkOperation.completionHandler = completionBlock
        let key = imageURL.absoluteString
        operationManager.addNewOperation(networkOperation, key: key)
        return networkOperation
    }
    
    func stopImageLoading(imageURL: NSURL) {
        let key = imageURL.absoluteString
        operationManager.cancelNetworkOperationWithKey(key)
    }
    
    
}