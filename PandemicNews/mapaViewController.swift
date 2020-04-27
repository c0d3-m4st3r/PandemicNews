//
//  mapaViewController.swift
//  PandemicNews
//
//  Created by user152439 on 4/27/20.
//  Copyright © 2020 FJPAFRV2020. All rights reserved.
//

import WebKit

class mapaViewController: UIViewController, WKNavigationDelegate {

    
    var webView : WKWebView!
    
    
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let  url = URL(string: "https://google.com/covid19-map/?hl=es")!
        webView.load(URLRequest(url: url))
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
        
    }
  

}
