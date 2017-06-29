//
//  le_wenDetailViewController.swift
//  12
//
//  Created by 王吉吉 on 2016/12/27.
//  Copyright © 2016年 王喆. All rights reserved.
//

import UIKit
import WebKit
class le_wenDetailViewController: UIViewController,WKNavigationDelegate,WKUIDelegate {
    var id = ""
    var wawaUrl = "http://wawa.fm/webview/musician_detail.html?uid=46018&id=%@"
    override func viewDidLoad() {
        super.viewDidLoad()
        let webView = WKWebView()
        webView.uiDelegate = self
        webView.navigationDelegate = self
        let url = NSURL.init(string: String(format:wawaUrl,id))
        let urlRequest = NSURLRequest.init(url: url! as URL)
        webView.frame = self.view.frame
        webView.load(urlRequest as URLRequest)
        self.view.addSubview(webView)
        
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let requestUrl = navigationAction.request.url 
        let requestStr = requestUrl?.absoluteString
        if requestStr == String(format:wawaUrl,id){
            decisionHandler(WKNavigationActionPolicy.allow)
            return
        }else{
            let next = NextWebView()
            next.url = requestStr!
            self.navigationController?.pushViewController(next, animated: true)
            decisionHandler(WKNavigationActionPolicy.cancel)
            
        }
    }
    
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   }
