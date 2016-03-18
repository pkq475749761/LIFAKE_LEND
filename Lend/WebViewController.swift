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
        super.viewDidLoad()
        webView.delegate=self
        webView.scrollView.bounces=false
        let req=NSURLRequest(URL: NSURL(string: "192.168.9.110:28880")!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringCacheData, timeoutInterval: 5)
        webView.loadRequest(req)
    }

    //内存不足时警告
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //隐藏状态栏
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    //如果带jsbean参数，则进行注入
    func webViewDidFinishLoad(webView: UIWebView) {
        print("finish")
        if let query=webView.request?.URL?.query{
            if query.containsString("jsbean"){
                print("JavaScript模型正在注入")
                JavaScriptContext.getAndExport(self)
            }
        }
    }
    
    //网络不好时加载本地html
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        NSLog("\(error?.code)")
        let filePath=NSBundle.mainBundle().pathForResource("error", ofType: "html")
        let file=NSFileManager.defaultManager().contentsAtPath(filePath!)
        webView.loadData(file!, MIMEType: "text/html", textEncodingName: "UTF-8",baseURL: NSURL(string: "http://192.168.9.110:28880/")!)
    }

    
    
    
}
