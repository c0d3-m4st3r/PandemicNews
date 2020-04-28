//
//  mapawebview.swift
//  PandemicNews
//
//  Created by user152439 on 4/28/20.
//  Copyright © 2020 FJPAFRV2020. All rights reserved.
//

import WebKit

class mapawebview: UIViewController, WKNavigationDelegate, UIWebViewDelegate{

    
    
    @IBOutlet weak var numPaises: UILabel!
    
     var mapa : WKWebView!
    
    @IBOutlet weak var numRecuperados: UILabel!
    
    @IBOutlet weak var numInfectados: UILabel!
    
    override func loadView() {
        mapa = WKWebView()
        mapa.navigationDelegate = self
        view = mapa
    }
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let  url = URL(string: "https://google.com/covid19-map/?hl=es")!
        mapa.load(URLRequest(url: url))
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = mapa.title
        
    }
    
}
