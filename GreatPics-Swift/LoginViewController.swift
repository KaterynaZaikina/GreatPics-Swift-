//
//  LoginViewController.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 11/23/15.
//  Copyright © 2015 kateryna.zaikina. All rights reserved.
//

import Foundation
import UIKit
import KeychainAccess

private let INSTAGRAM_AUTH_URL = "https://api.instagram.com/oauth/authorize/?"
private let INSTAGRAM_REDIRECT_URI = "https://yalantis.com"
private let INSTAGRAM_CLIENT_SECRET = "5d245e1de66a4f75a4779468c03a8f8d"
private let INSTAGRAM_CLIENT_ID  = "ffce67cce0814cb996eef468646cf08f"
private let kMainStoryboardName = "Main"
private let kLoginViewControllerIdentfier = "LoginViewController"

class LoginViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    typealias loginCompletionBlock = (String?) -> ()
    var completionBlock: loginCompletionBlock?
    
    class func loginControllerWithCompletionBlock(completionBlock: loginCompletionBlock) -> LoginViewController {
        let sb = UIStoryboard(name:kMainStoryboardName, bundle:nil)
        let loginController = sb.instantiateViewControllerWithIdentifier(kLoginViewControllerIdentfier) as! LoginViewController
        loginController.completionBlock = completionBlock
        return loginController
    }
    
    //MARK: - Login
    func login() {
        let urlString = INSTAGRAM_AUTH_URL + "client_id=" + INSTAGRAM_CLIENT_ID + "&redirect_uri=" + INSTAGRAM_REDIRECT_URI + "&response_type=token"
        let url = NSURL(string: urlString)
        if let url = url {
            let request = NSURLRequest(URL: url)
            webView.loadRequest(request)
        }
    }
    
    //MARK: - Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        login()
    }
}

//MARK: - WebView Delegate
extension LoginViewController: UIWebViewDelegate {
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
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

