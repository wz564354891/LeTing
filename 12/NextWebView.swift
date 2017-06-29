//
//  NextWebView.swift
//  12
//
//  Created by 王吉吉 on 2016/12/13.
//  Copyright © 2016年 王喆. All rights reserved.
//

import UIKit
import WebKit
class NextWebView: UIViewController ,WKNavigationDelegate,WKUIDelegate{
    var url = ""
    var webView = UIWebView()
    override func viewDidLoad() {
        super.viewDidLoad()
        let webView = WKWebView()
        webView.uiDelegate = self
        webView.navigationDelegate = self
        let url = NSURL.init(string: self.url)
        let urlRequest = NSURLRequest.init(url: url! as URL)
        webView.frame = self.view.frame
        webView.load(urlRequest as URLRequest)
        self.view.addSubview(webView)
        
    }
    
}
