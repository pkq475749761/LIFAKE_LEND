//
//  WebViewController.swift
//  Lend
//
//  Created by alexlee on 16/3/16.
//  Copyright © 2016年 bird. All rights reserved.
//

import UIKit

class WebViewController: UIViewController,UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        NSLog("JavaScript模型正在注入")
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        if let query=webView.request?.URL?.query{
            if query.containsString("jsbean"){
                print("JavaScript模型正在注入")
                
            }else{
                print("not contain!")
                
            }
        }else{
            print("not str!")
        }
    }

    
    
    
}
