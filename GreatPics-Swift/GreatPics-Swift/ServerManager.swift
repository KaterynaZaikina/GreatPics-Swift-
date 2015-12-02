//
//  ServerManager.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 11/24/15.
//  Copyright © 2015 kateryna.zaikina. All rights reserved.
//

import Foundation
import AFNetworking

private let tag = "mycar"
private let postNumber = "20"
private let baseURL = "https://api.instagram.com/v1/"

class ServerManager {
    
    var accessToken: String?
    private let defaults = NSUserDefaults.standardUserDefaults()
    private var pagination: [String: String]?
    
    private var maxTagID: String? {
        get {
           return defaults.valueForKey("maxTagID") as? String
        }
        set(newValue) {
            defaults.setObject(newValue, forKey: "maxTagID")
        }
    }
    
    static let sharedManager = ServerManager()
    private let networkingManger = NetworkingManager(baseURL: baseURL)
    
    func loadFirstPageOfPosts() {
        loadPostsWithMaxTagID(maxTagID)
    }
    
    func loadNextPageOfPosts() {
        maxTagID = pagination?["next_max_id"]
        loadPostsWithMaxTagID(maxTagID)
    }
    
    private func recentPostsForTagName(tagName:String, count:String, maxTagID:String?, success:([String : AnyObject]? -> Void)?, failure:(NSError -> Void)?) {
        
        let urlString = "tags/\(tagName)/media/recent"
        var parameters = [String: String]()
        if accessToken != nil {
            parameters["access_token"] = accessToken
        }
        
        if maxTagID != nil {
            parameters["max_tag_id"] = maxTagID
        }
        
        parameters["count"] = count
        
        
        do {
            try networkingManger.sendGETRequest(urlString, parameters: parameters, success: success, failure: failure)
        } catch  {
            print("error response object")
        }
        
    }
    
    func loadImageWithURL(imageURL: NSURL, completionBlock: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSOperation {
        return  networkingManger.loadWithRequest(imageURL, completionBlock: completionBlock)
    }
    
    private func loadPostsWithMaxTagID(maxTagID:String?) {
        recentPostsForTagName(tag, count: postNumber, maxTagID: maxTagID, success: { [unowned self] responseObject in
            if let paginationDictionary = responseObject?["pagination"] as? [String : String]  {
                self.pagination = paginationDictionary
            }
            
            let manager = InstaPostManager()
            if let postsDictionary = responseObject?["data"] as? [AnyObject]  {
                manager.importPost(postsDictionary)
            }
            }) { error in
                print("error - \(error.localizedDescription), status code - \(error.code)")
        }
    }
    
}


