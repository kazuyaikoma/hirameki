//
//  WebViewController.swift
//  BrainBot
//
//  Created by KazuyaIkoma on 2019/01/22.
//  Copyright © 2019 kaz. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    var urlString = "https://www.google.com/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let encodedUrlString = self.urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed),
            let url = NSURL(string: encodedUrlString) as URL?,
            let tabHeight = self.parent?.tabBarController?.tabBar.frame.height else {
                return
        }
        
        self.webView = WKWebView(frame: CGRect(x:0, y:0, width: self.view.bounds.size.width, height: self.view.bounds.size.height - tabHeight))
        
        let request = NSURLRequest(url: url)
        self.webView.load(request as URLRequest)
        self.view.addSubview(self.webView)
        
    }
}
