//
//  ServerManager.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 11/24/15.
//  Copyright © 2015 kateryna.zaikina. All rights reserved.
//

import Foundation
import AFNetworking

class ServerManager {
    
    var accessToken: String?
    private let sessionManager: AFHTTPSessionManager
    private var pagination: Dictionary<String, String>?
    static let sharedManager = ServerManager()
    
    init() {
        let url = NSURL(string: "https://api.instagram.com/v1/")
        sessionManager = AFHTTPSessionManager(baseURL: url)
    }
    
    func loadFirstPageOfPosts() {
        loadPostsWithMaxTagID(nil)
    }
    
    func loadNextPageOfPosts() {
        loadPostsWithMaxTagID(pagination?["next_max_tag_id"])
    }
    
    private func recentPostsForTagName(tagName:String, count:Int, maxTagID:String?, success:(AnyObject? -> Void)?, failure:(NSError -> Void)?) {
        let urlString = "tags/\(tagName)/media/recent"
        var parameters = [String: AnyObject]()
        if let accessToken = accessToken {
            parameters["access_token"] = accessToken
        }
        parameters["count"] = count
        if let maxTagID = maxTagID {
            parameters["max_tag_id"] = maxTagID
        }
        
        sessionManager.GET(urlString, parameters: parameters, success: { operation, responseObject in
            if let responseObject = responseObject {
                success?(responseObject)
            } else {
                let userInfo = ["localizedDescription":"Response Object is not recieved"]
                let error = NSError(domain:"com.yalantis.GreatPics.instagram", code:333, userInfo: userInfo)
                print("error - \(error.localizedDescription), status code - \(error.code)")
            }
            }, failure: { (operation:NSURLSessionDataTask?, error:NSError) -> Void in
                failure?(error)
        })
        
    }
    
    private func loadPostsWithMaxTagID(maxTagID:String?) {
        let numberOfPostLoaded = 20
        recentPostsForTagName("workhardanywhere", count: numberOfPostLoaded, maxTagID: maxTagID, success: { (responseObject) -> Void in
            print("\(responseObject)")
            // after adding InstaPostManager
            //    KVZInstaPostManager *manager = [[KVZInstaPostManager alloc] init];
            //    weakSelf.pagination = [responseObject valueForKey:@"pagination"];
            //    [manager importPosts:[responseObject valueForKey:@"data"]];
            }) { (error) -> Void in
                print("error - \(error.localizedDescription), status code - \(error.code)")
        }
    }
    
}
