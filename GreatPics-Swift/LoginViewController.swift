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

private let INSTAGRAM_AUTH_URL = "https://api.instagram.com/oauth/authorize/?"

class LoginViewController: UIViewController, UIWebViewDelegate {
    
//Review: Ты создала константу как константу инстанса класса т.е. теперь все могут до нее доступаться LoginViewController().YOUR_CONSTANT.
//я думаю ты хотела создать глобальную константу, вверху показано как это делать. Не забывай про спецификатор private. 
//в свифте не обязательны ; и рекомендуется их не ставить, если только ты не хочешь подчеркнуть разделение.
    
//    let INSTAGRAM_AUTH_URL = "https://api.instagram.com/oauth/authorize/?";
    let INSTAGRAM_REDIRECT_URI = "https://yalantis.com";
    let INSTAGRAM_CLIENT_SECRET = "5d245e1de66a4f75a4779468c03a8f8d";
    let INSTAGRAM_CLIENT_ID  = "ffce67cce0814cb996eef468646cf08f";

    @IBOutlet weak var webView: UIWebView!
    typealias loginComplitionBlock = (NSString) -> ()
    var completionBlock: loginComplitionBlock?
    
//Review: Скобки не нужны в конце, можно просто так:
//class func loginControllerWithCompletionBlock(completionBlock: loginComplitionBlock) -> LoginViewController
    class func loginControllerWithCompletionBlock(completionBlock: loginComplitionBlock) -> (LoginViewController) {
        let sb = UIStoryboard(name:"Main", bundle:nil)
        let loginController = sb.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        loginController.completionBlock = completionBlock
        return loginController
    }
    
    //MARK: - Login
    
    func login() {
//Review: В свифте есть такая штука как интерполяция String interpolation https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/StringsAndCharacters.html#//apple_ref/doc/uid/TP40014097-CH7-ID292 и 
//конкатенация https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/StringsAndCharacters.html#//apple_ref/doc/uid/TP40014097-CH7-ID291
//твой код будет выглядить так let urlString = INSTAGRAM_AUTH_URL + "cliend_id=" + INSTAGRAM_CLIENT_ID + "&redirect_uri" + "INSTAGRAM_REDIRECT_URI" + "&response_type=token"
        let urlString = String(format:"%@client_id=%@&redirect_uri=%@&response_type=token", INSTAGRAM_AUTH_URL, INSTAGRAM_CLIENT_ID, INSTAGRAM_REDIRECT_URI)
//Review: Метод init можно и нужно вызывать так NSURL(string: urlString)
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