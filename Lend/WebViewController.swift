//
//  WebViewController.swift
//  Lend
//  web控制器
//  Created by alexlee on 16/3/16.
//  Copyright © 2016年 bird. All rights reserved.
//

import UIKit

class WebViewController: UIViewController,UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    var hasError=false
    var lasturl:String? = nil
    var deadLoop=0

    
    override func viewDidLoad() {
        NSLog("设置USER-AGENT：%@",USER_AGENT)
        super.viewDidLoad()
        webView.delegate=self//设置委托
        webView.scrollView.bounces=false//禁止边界弹回效果
        let req=NSURLRequest(URL: NSURL(string: BASE_URL_INDEX)!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: REQ_INTERVAL)
        
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
        NSLog("页面加载完成：%@",webView.request?.URL?.absoluteString.stringByRemovingPercentEncoding ?? "获取url失败")
        
        //如果带jsbean参数，则进行注入
        if let query=webView.request?.URL?.query{
            if query.containsString("\(JSBEAN_NAME)=true"){
                NSLog("JavaScript模型正在注入")
                JavaScriptContext.getAndExport(self)
            }
        }
        
        //往error.html里设置超链接
        if let lurl=lasturl {
            if hasError{
                webView.stringByEvaluatingJavaScriptFromString("document.getElementById('reload').href='\(lurl)'")
            }else{
                lasturl=nil
            }
            hasError=false
        }
        webView.stringByEvaluatingJavaScriptFromString("document.getElementById('pic').src='file://\(ERROR_PIC_URL)'")
        
        deadLoop = 0
        
    }
    
    //网络不好时加载本地html
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        //防止死循环
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
            
            if let file=NSFileManager.defaultManager().contentsAtPath(ERROR_PAGE_URL),burl=NSURL(string: "local"){
                webView.loadData(file, MIMEType: "text/html", textEncodingName: "UTF-8",baseURL: burl)
            }
        }
        deadLoop += 1
    }

    
    
    
}
