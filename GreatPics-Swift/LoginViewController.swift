//
//  LoginViewController.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 11/23/15.
//  Copyright © 2015 kateryna.zaikina. All rights reserved.
//

import UIKit
import KeychainAccess

private struct Constants {
    
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
        let url = NSURL(string: InstagramConfig.loginURLString())
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
        let accessToken = InstagramConfig.findAccessToken(urlStringExist)
        if !accessToken.isEmpty {
            if let completionBlock = completionBlock {
                completionBlock(accessToken)
            }
            return false
        }
        return true
    }
    
}

