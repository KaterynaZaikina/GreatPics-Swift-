//
//  ServerManager.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 11/24/15.
//  Copyright © 2015 kateryna.zaikina. All rights reserved.
//

import Foundation
import AFNetworking

private let errorDomain = "com.yalantis.GreatPics.instagram"
private let errorCode = 333

class ServerManager {
    
    var accessToken: String?
    private let sessionManager: AFHTTPSessionManager
    private var pagination: [String: String]?
    static let sharedManager = ServerManager()
    
    private init() {
        let url = NSURL(string: "https://api.instagram.com/v1/")
        sessionManager = AFHTTPSessionManager(baseURL: url)
    }
    
    func loadFirstPageOfPosts() {
        loadPostsWithMaxTagID(nil)
    }
    
    func loadNextPageOfPosts() {
        loadPostsWithMaxTagID(pagination?["next_max_tag_id"])
    }
    
    private func recentPostsForTagName(tagName:String, count:Int = 20, maxTagID:String?, success:(AnyObject? -> Void)?, failure:(NSError -> Void)?) {
        let urlString = "tags/\(tagName)/media/recent"
        var parameters = [String: AnyObject]()
        parameters["access_token"] = accessToken
        parameters["count"] = count
        parameters["max_tag_id"] = maxTagID
        
        sessionManager.GET(urlString, parameters: parameters, success: { operation, responseObject in
            if let responseObject = responseObject {
                success?(responseObject)
            } else {
                let userInfo = [NSLocalizedDescriptionKey : "Response Object is not recieved"]
                let error = NSError(domain:errorDomain, code:errorCode, userInfo: userInfo)
                print("error - \(error.localizedDescription), status code - \(error.code)")
            }
            }, failure: { (operation:NSURLSessionDataTask?, error:NSError) -> Void in
                failure?(error)
        })
        
    }
    
    private func loadPostsWithMaxTagID(maxTagID:String?) {
        recentPostsForTagName("workhardanywhere", maxTagID: maxTagID, success: { responseObject in
            print("\(responseObject)")
            // after adding InstaPostManager
            //    KVZInstaPostManager *manager = [[KVZInstaPostManager alloc] init];
            //    weakSelf.pagination = [responseObject valueForKey:@"pagination"];
            //    [manager importPosts:[responseObject valueForKey:@"data"]];
            }) { error in
                print("error - \(error.localizedDescription), status code - \(error.code)")
        }
    }
    
}
