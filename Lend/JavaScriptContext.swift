//
//  JavaScriptContext.swift
//  Lend
//
//  Created by alexlee on 16/3/16.
//  Copyright © 2016年 bird. All rights reserved.
//

import Foundation
import JavaScriptCore

@objc protocol JavaScriptContextProtocol: JSExport{
    func callCamera();
    func callContact();
}
@objc class JavaScriptContext:NSObject,JavaScriptContextProtocol{
    var controller:WebViewController?
    var jsContext:JSContext?
    func callCamera(){
        print("use camera")
    }
    func callContact(){
        print("use contact")
    }
}