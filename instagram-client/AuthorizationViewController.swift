//
//  AuthorizationViewController.swift
//  instagram-client
//
//  Created by kuzindmitry on 11.07.17.
//  Copyright © 2017 Dmitry Kuzin. All rights reserved.
//

import Foundation
import UIKit

class AuthorizationViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let clientId = "a2619568d02c475583f1931bed7b5491"
    let redirectUri = "https://instagram.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.loadRequest(URLRequest.init(url: URL(string: "https://api.instagram.com/oauth/authorize/?client_id=\(clientId)&scope=public_content+follower_list+relationships+comments+likes&redirect_uri=\(redirectUri)&response_type=token")!))
    }
    
}

extension AuthorizationViewController: UIWebViewDelegate {
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if let url = request.url?.absoluteString {
            if url.range(of: "#access_token") != nil {
                let access_token = url.components(separatedBy: "#access_token=").last!
                Credential.token = access_token
                self.present((self.storyboard?.instantiateInitialViewController())!, animated: true, completion: nil)
            }
        }
        return true
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        activityIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicator.stopAnimating()
    }
    
}
