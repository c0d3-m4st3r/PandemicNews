//
//  MapaMundiViewController.swift
//  PandemicNews
//
//  Created by user152439 on 4/28/20.
//  Copyright © 2020 FJPAFRV2020. All rights reserved.
//

import UIKit
import WebKit

class MapaMundiViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var casosTotales: UILabel!
    @IBOutlet weak var paisesInfectados: UILabel!
    @IBOutlet weak var recuperadosTotales: UILabel!
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        casosTotales.text = "0"
        paisesInfectados.text = "0"
        recuperadosTotales.text = "0"
        
        let myURL = URL(string: "https://www.google.com/covid19-map/?hl=es-419")
        let myRequest = URLRequest(url: myURL!)
        
        
        webView.load(myRequest)
        

    }
    
    

    

}
