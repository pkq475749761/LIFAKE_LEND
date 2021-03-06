//
//  JavaScriptContext.swift
//  Lend
//  javascript模型
//  Created by alexlee on 16/3/16.
//  Copyright © 2016年 bird. All rights reserved.
//

import UIKit
import JavaScriptCore

//定义javascript模型的接口
@objc protocol JavaScriptContextProtocol: JSExport{
    func callCamera(token:String);
    func callContact(token:String);
}
//实现模型
@objc class JavaScriptContext:NSObject,JavaScriptContextProtocol{
    let controller:WebViewController!
    let jsContext:JSContext!
    let imagePicker:ImagePicker!
    let contactPicker:ContactPicker!
    let contactUploader:ContactUploader!
    
    init(controller:WebViewController,jsContext:JSContext){
        self.controller=controller
        self.jsContext=jsContext
        imagePicker=ImagePicker(controller: controller,jsContext: jsContext)
        contactPicker=ContactPicker(controller: controller,jsContext:jsContext)
        contactUploader=ContactUploader()
    }
    //js呼叫方法，拍照
    func callCamera(token:String){
        imagePicker.openCamera(token)
    }
    //js呼叫方法，获取联系人
    func callContact(token:String){
        contactPicker.openContactList()
        if token != ""{
            dispatch_async(dispatch_get_global_queue(0, 0), {
                self.contactUploader.uploadAll(token)
            })
            print("异步")
            let jsFunc=jsContext.objectForKeyedSubscript("updateState")
            jsFunc?.callWithArguments([1])
        }
    }
    
    //创建js模型并注入到webview
    static func getAndExport(webViewController:WebViewController)->JavaScriptContext?{
        var model:JavaScriptContext?=nil
        if let context=webViewController.webView.valueForKeyPath("documentView.webView.mainFrame.javaScriptContext") as? JSContext{
            model=JavaScriptContext(controller: webViewController, jsContext: context)
            context.setObject(model, forKeyedSubscript:JSBEAN_NAME)
            context.exceptionHandler={
                (context,e) in
                NSLog("创建js模型失败：%@","\(e)")
            }
        }else{
            NSLog("创建js模型失败")
        }
        return model
    }
}