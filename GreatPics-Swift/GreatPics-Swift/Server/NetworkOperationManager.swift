//
//  NetworkOperationManager.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 12/2/15.
//  Copyright © 2015 kateryna.zaikina. All rights reserved.
//

import Foundation

final public class NetworkOperationManager {
    
    private let networkOperationQueue: NSOperationQueue
    private var operations = [String: NSOperation]()
    
    //MARK: - init/deinit
    init() {
        networkOperationQueue = NSOperationQueue()
        networkOperationQueue.maxConcurrentOperationCount = 5
    }
    
    //MARK: - Public methods
    func addNewOperation(operation: NSOperation, key: String) {
        operations[key] = operation
        networkOperationQueue.addOperation(operation)
    }
    
    func cancelNetworkOperationWithKey(key: String) {
        operations[key]?.cancel()
        operations.removeValueForKey(key)
    }
    
    func cancelAllOperations() {
        networkOperationQueue.cancelAllOperations()
    }
    
}
