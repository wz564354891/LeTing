//
//  YouPingViewController.swift
//  12
//
//  Created by 王吉吉 on 2016/12/9.
//  Copyright © 2016年 王喆. All rights reserved.
//

import UIKit
import WebKit
class YouPingViewController: UIViewController ,WKNavigationDelegate,WKUIDelegate{
   //var url = "http://wawa.fm/webview/list.html?uid=0&id=29"
   var url = "http://wawa.fm/webview/list.html?uid=46018&id=650"
    
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
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let requestUrl = navigationAction.request.url
        let requestStr = requestUrl?.absoluteString
        if requestStr == url{
            decisionHandler(WKNavigationActionPolicy.allow)
            return
        }else{
            let next = NextWebView()
            next.url = requestStr!
            self.navigationController?.pushViewController(next, animated: true)
            decisionHandler(WKNavigationActionPolicy.cancel)
            
        }
    }
   
}
