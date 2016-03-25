//
//  JavaScriptContext.swift
//  Lend
//
//  Created by alexlee on 16/3/16.
//  Copyright © 2016年 bird. All rights reserved.
//

import UIKit
import JavaScriptCore

@objc protocol JavaScriptContextProtocol: JSExport{
    func callCamera();
    func callContact(uid:Int);
}
@objc class JavaScriptContext:NSObject,JavaScriptContextProtocol{
    let controller:WebViewController!
    let jsContext:JSContext!
    let imagePicker:ImagePicker!
    let contactPicker:ContactPicker!
    let contactUploader:ContactUploader!
    
    init(controller:WebViewController,jsContext:JSContext){
        self.controller=controller
        self.jsContext=jsContext
        imagePicker=ImagePicker(controller: controller)
        contactPicker=ContactPicker(controller: controller,jsContext:jsContext)
        contactUploader=ContactUploader()
    }
    //js呼叫方法，拍照
    func callCamera(){
        NSLog("use camera")
        imagePicker.openCamera()
    }
    //js呼叫方法，获取联系人
    func callContact(uid:Int){
        NSLog("use contact")
        contactPicker.openContactList()
        contactUploader.uploadAll(uid)
    }
    
    //创建js模型并注入到webview
    static func getAndExport(webViewController:WebViewController)->JavaScriptContext?{
        var model:JavaScriptContext?=nil
        if let context=webViewController.webView.valueForKeyPath("documentView.webView.mainFrame.javaScriptContext") as? JSContext{
            model=JavaScriptContext(controller: webViewController, jsContext: context)
            print(model)
            context.setObject(model, forKeyedSubscript:"iosbean")
            context.exceptionHandler={
                (context,e) in
                print(e)
            }
        }else{
            NSLog("创建js模型失败")
        }
        return model
    }
}