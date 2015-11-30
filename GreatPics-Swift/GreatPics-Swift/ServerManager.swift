//
//  ServerManager.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 11/24/15.
//  Copyright © 2015 kateryna.zaikina. All rights reserved.
//

import Foundation
import AFNetworking

private let tag = "selfie"
private let postNumber = "20"

class ServerManager {
    
    var accessToken: String?
    
    //    private let sessionManager: AFHTTPSessionManager
    private var pagination: [String: String]?
    static let sharedManager = ServerManager()
    
    func loadFirstPageOfPosts() {
        loadPostsWithMaxTagID(nil)
    }
    
    func loadNextPageOfPosts() {
        loadPostsWithMaxTagID(pagination?["next_max_id"])
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
        let baseURL = "https://api.instagram.com/v1/"
        
        do {
            try NetworkingManager(baseURL: baseURL).sendGETRequest(urlString, parameters: parameters, success: success, failure: failure)
        } catch  {
            print("error response object")
        }
        
        
        //        sessionManager.GET(urlString, parameters: parameters, success: { operation, responseObject in
        //            if let responseObject = responseObject as? [String : AnyObject] {
        //                success?(responseObject)
        //                } else {
        //                let userInfo = [NSLocalizedDescriptionKey : "Response Object is not recieved"]
        //                let error = NSError(domain:errorDomain, code:errorCode, userInfo: userInfo)
        //                print("error - \(error.localizedDescription), status code - \(error.code)") }
        //            }, failure: { (operation:NSURLSessionDataTask?, error:NSError) -> Void in
        //                failure?(error)
        //        })
    }
    
    private func loadPostsWithMaxTagID(maxTagID:String?) {
        recentPostsForTagName(tag, count: postNumber, maxTagID: maxTagID, success: { responseObject in
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


