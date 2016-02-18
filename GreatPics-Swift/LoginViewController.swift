//
//  LoginViewController.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 11/23/15.
//  Copyright © 2015 kateryna.zaikina. All rights reserved.
//

import UIKit
import KeychainAccess

//MARK: Code_Review_18.02.2016: ViewController should not know about Insta urls, ids and atc
private struct Constants {
    struct Instagram {
        static let instagramAuthURL = "https://api.instagram.com/oauth/authorize/?"
        static let instagramRedirectURL = "https://yalantis.com"
        static let instagramClientSecret = "5d245e1de66a4f75a4779468c03a8f8d"
        static let instagramClientID  = "ffce67cce0814cb996eef468646cf08f"
        static var loginURL = Constants.Instagram.instagramAuthURL + "client_id=" + Constants.Instagram.instagramClientID + "&redirect_uri=" + Constants.Instagram.instagramRedirectURL + "&response_type=token"
        
    }
    
    struct StoryboardID {
        static let mainStoryboardID = "Main"
        static let loginViewControllerID = "LoginViewController"
    }

}

final public class LoginViewController: UIViewController {
    
    typealias loginCompletionBlock = (String?) -> ()
    
    @IBOutlet private weak var webView: UIWebView!
    var completionBlock: loginCompletionBlock?
    
    //MARK: - Class Methods
    class func loginControllerWithCompletionBlock(completionBlock: loginCompletionBlock) -> LoginViewController {
        let sb = UIStoryboard(name:Constants.StoryboardID.mainStoryboardID, bundle:nil)
        let loginController = sb.instantiateViewControllerWithIdentifier(Constants.StoryboardID.loginViewControllerID) as! LoginViewController
        loginController.completionBlock = completionBlock
        return loginController
    }
    
    //MARK: - Controller lifecycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        login()
    }
    
    //MARK: - Public methods
    func login() {
        let url = NSURL(string: Constants.Instagram.loginURL)
        if let url = url {
            let request = NSURLRequest(URL: url)
            webView.loadRequest(request)
        }
    }
    
}

//MARK: - WebView Delegate
extension LoginViewController: UIWebViewDelegate {
    
  public func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let urlString = request.URL?.absoluteString
        guard let urlStringExist = urlString else {
            return false
        }
        let accessToken = TokenFinder.findAccessToken(urlStringExist)
        if !accessToken.isEmpty {
            if let completionBlock = completionBlock {
                completionBlock(accessToken)
            }
            return false
        }
        return true
    }
    
}

