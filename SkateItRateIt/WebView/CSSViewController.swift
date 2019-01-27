//
//  CSSViewController.swift
//  SkateItRateIt
//
//  Created by Kim Lyndon on 1/5/19.
//  Copyright © 2019 Kim Lyndon. All rights reserved.
//

import UIKit
import WebKit

class CSSViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let url = URL(string: "https://www.ebay.com/str/californiaskateboardsupply")
        let request = URLRequest(url: url!)
        webView.load(request)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
