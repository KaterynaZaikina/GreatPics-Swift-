//
//  LoginViewController.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 11/23/15.
//  Copyright © 2015 kateryna.zaikina. All rights reserved.
//

import Foundation
import UIKit

import AFNetworking

class LoginViewController: UIViewController, UIWebViewDelegate {
    
    let INSTAGRAM_AUTH_URL = "https://api.instagram.com/oauth/authorize/?";
    let INSTAGRAM_REDIRECT_URI = "https://yalantis.com";
    let INSTAGRAM_CLIENT_SECRET = "5d245e1de66a4f75a4779468c03a8f8d";
    let INSTAGRAM_CLIENT_ID  = "ffce67cce0814cb996eef468646cf08f";

    @IBOutlet weak var webView: UIWebView!
    typealias loginComplitionBlock = (NSString) -> ()
    var completionBlock: loginComplitionBlock?
    
    class func loginControllerWithCompletionBlock(completionBlock: loginComplitionBlock) -> (LoginViewController) {
        let sb = UIStoryboard(name:"Main", bundle:nil)
        let loginController = sb.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        loginController.completionBlock = completionBlock
        return loginController
    }
    
    //MARK: - Login
    
    func login() {
        let urlString = String(format:"%@client_id=%@&redirect_uri=%@&response_type=token", INSTAGRAM_AUTH_URL, INSTAGRAM_CLIENT_ID, INSTAGRAM_REDIRECT_URI)
        let url = NSURL.init(string: urlString)
        let request = NSURLRequest.init(URL:url!)
        webView.loadRequest(request)
    }
    
    //MARK: - WebView Delegate
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let urlString = request.URL?.absoluteString
        let accessToken = TokenFinder.accessTokenDidFind(urlString!)
        if accessToken.characters.count != 0 {
            if (completionBlock != nil) {
            completionBlock!(accessToken)
            }
            return false
        }
        return true
    }
    
    //MARK: - Controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        login()
    }
    
}