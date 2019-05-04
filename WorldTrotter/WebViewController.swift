//
//  WebViewController.swift
//  WorldTrotter
//
//  Created by Yisselda Rhoc on 5/4/19.
//  Copyright © 2019 YR. All rights reserved.
//

import UIKit
import WebKit

class WebViewController : UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = URL(string: "https://www.bignerdranch.com") {
            let request = URLRequest(url: url)
            webView.load(request)
            webView.allowsBackForwardNavigationGestures = true
        }
    }
}
