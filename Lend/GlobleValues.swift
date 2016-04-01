//
//  GlobleValues.swift
//  Lend
//  全局变量
//  Created by alexlee on 16/3/28.
//  Copyright © 2016年 bird. All rights reserved.
//

import UIKit

//网络
public let BASE_URL="http://192.168.9.111:28880/"//域名
public let BASE_URL_INDEX=BASE_URL+"index?client=2"//首页地址
public let REQ_INTERVAL:NSTimeInterval=5//超时秒数
public let USER_AGENT = getDefaultAgent()
func getDefaultAgent()->String{
    let webview=UIWebView()
    var result=webview.stringByEvaluatingJavaScriptFromString("navigator.userAgent")!
    result += ";ioshema"
    NSUserDefaults.standardUserDefaults().registerDefaults(["UserAgent":result])
    return result
}

//图片
public let COMPRESS_VAL:CGFloat=0.5//压缩系数
public let WATERMARK_VAL="河马大叔"//水印文字
public let TEMPFILE_URL=NSTemporaryDirectory()+"pic.jpg"//图片临时存放地址

//异常
public let ERROR_PIC_URL=NSBundle.mainBundle().pathForResource("error", ofType: "jpg")!//错误页面图片
public let ERROR_PAGE_URL=NSBundle.mainBundle().pathForResource("error", ofType: "html")!//错误页面

//javascript
public let JSBEAN_NAME="app"//javascript模型名字

