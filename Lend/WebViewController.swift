//
//  WebViewController.swift
//  Lend
//
//  Created by alexlee on 16/3/16.
//  Copyright © 2016年 bird. All rights reserved.
//

import UIKit

public let BASE_URL="http://192.168.9.111:28880/"
public let BASE_URL_INDEX=BASE_URL+"index?client=2"

class WebViewController: UIViewController,UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    var hasError=false
    var lasturl:String? = nil
    var deadLoop=0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate=self
        webView.scrollView.bounces=false
        let req=NSURLRequest(URL: NSURL(string: BASE_URL_INDEX)!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
        
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
    
    func webViewDidFinishLoad(webView: UIWebView) {
        NSLog("页面加载完成")
            
        //如果带jsbean参数，则进行注入
        if let query=webView.request?.URL?.query{
            print(query)
            if query.containsString("iosbean"){
                print("JavaScript模型正在注入")
                JavaScriptContext.getAndExport(self)
            }
        }
        
        //往error.html里设置超链接
        if let url=lasturl {
            if hasError{
                webView.stringByEvaluatingJavaScriptFromString("document.getElementById('reload').href='\(url)'")
            }else{
                lasturl=nil
            }
            hasError=false
        }
        webView.stringByEvaluatingJavaScriptFromString("document.getElementById('pic').src='file://\(NSBundle.mainBundle().pathForResource("error", ofType: "jpg")!)'")
        
        deadLoop = 0
        
    }
    
    //网络不好时加载本地html
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        if deadLoop == 0{
            if lasturl==nil
            {
                let aStr=webView.request?.URL?.absoluteString
                if aStr==nil || aStr=="file://local" || aStr==""{
                    lasturl=BASE_URL_INDEX
                }else{
                    lasturl=aStr
                }
            }
            hasError=true
            
            print(webView.request?.URL?.absoluteString)
            print(NSBundle.mainBundle().pathForResource("error", ofType: "html"))
            
            let filePath=NSBundle.mainBundle().pathForResource("error", ofType: "html")
            let file=NSFileManager.defaultManager().contentsAtPath(filePath!)
            webView.loadData(file!, MIMEType: "text/html", textEncodingName: "UTF-8",baseURL: NSURL(string: "local")!)
        }
        deadLoop += 1
    }

    
    
    
}
