//
//  WebViewController.swift
//  NewsApp
//
//  Created by Andrey on 05.05.2023.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    var currentUrl: String?
    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.allowsLinkPreview = true
        view = webView
    }
    
    override func viewDidLoad() {
        if let url = URL(string: currentUrl!) {
            print(url)
            webView.load(URLRequest(url: url))
        } else {
            print("error with web")
        }
    }
    
    
    
}
