//
//  ServerManager.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 11/24/15.
//  Copyright © 2015 kateryna.zaikina. All rights reserved.
//

import Foundation
//MARK: Code_Review_18.02.2016: Remove it
//import AFNetworking

private struct Constants {
    
    static let postNumber = "20"
    static let tag = "dnepr"
    static let baseURL = "https://api.instagram.com/v1/"
    static let maxTagID = "maxTagID"
    static let maxTagIDRequest = "max_tag_id"
    static let nextMaxTagID = "next_max_id"
    static let urlString = "tags/" + Constants.tag + "/media/recent"
    static let accessToken = "access_token"
    static let pagination = "pagination"
    static let data = "data"
    static let count = "count"
    
}


final public class ServerManager {
    
    private var pagination: [String: String]?
    private let defaults = NSUserDefaults.standardUserDefaults()
    private let networkingManger = NetworkingManager(baseURL: Constants.baseURL)
    
    private var maxTagID: String? {
        get {
            return defaults.valueForKey(Constants.maxTagID) as? String
        }
        set(newValue) {
            defaults.setObject(newValue, forKey: Constants.maxTagID)
        }
    }
    
    var accessToken: String?
    static let sharedManager = ServerManager()
    
    //MARK: - Private methods
    private func recentPostsForTagName(tagName:String, count:String, maxTagID:String?, success:([String : AnyObject]? -> Void)?, failure:(NSError -> Void)?) {
        let urlString = Constants.urlString
        var parameters = [String: String]()
        if let accessToken = accessToken {
            parameters[Constants.accessToken] = accessToken
        }
        
        if let maxTagID = maxTagID {
            parameters[Constants.maxTagIDRequest] = maxTagID
        }
        
        parameters[Constants.count] = count
        do {
            try networkingManger.sendGETRequest(urlString, parameters: parameters, success: success, failure: failure)
        } catch  {
            print("error response object")
        }
        
    }
    
    private func loadPostsWithMaxTagID(maxTagID: String?) {
        recentPostsForTagName(Constants.tag, count: Constants.postNumber, maxTagID: maxTagID, success: { [unowned self] responseObject in
            if let paginationDictionary = responseObject?[Constants.pagination] as? [String : String]  {
                self.pagination = paginationDictionary
            }
            
            let manager = InstaPostManager()
            if let postsDictionary = responseObject?[Constants.data] as? [AnyObject]  {
                manager.importPost(postsDictionary)
            }
            }, failure: { error in
                print("error - \(error.localizedDescription), status code - \(error.code)")
        })
    }
//MARK: Code_Review_18.02.2016: Use only one func
    //MARK: - Public methods
    func loadFirstPageOfPosts() {
        loadPostsWithMaxTagID(maxTagID)
    }
    
    func loadNextPageOfPosts() {
        maxTagID = pagination?[Constants.nextMaxTagID]
        loadPostsWithMaxTagID(maxTagID)
    }
    
}


