//
//  ImagePicker.swift
//  Lend
//  拍照
//  Created by alexlee on 16/3/16.
//  Copyright © 2016年 bird. All rights reserved.
//

import UIKit
import MobileCoreServices
import JavaScriptCore

class ImagePicker: NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    let controller:WebViewController
    let jsContext:JSContext
    var token:String?
    
    init(controller:WebViewController,jsContext:JSContext){
        self.controller=controller
        self.jsContext=jsContext
    }
    
    //开启摄像头
    func openCamera(token:String){
        NSLog("正在打开摄像头")
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            
            //根据指定的SourceType来获取该SourceType下可以用的媒体类型，返回的是一个数组
            let mediaTypeArr:NSArray = UIImagePickerController.availableMediaTypesForSourceType(UIImagePickerControllerSourceType.Camera)!
            if mediaTypeArr.containsObject(kUTTypeImage){
                
                //创建一个UIImagePickerController
                let pickerControl = UIImagePickerController()
                pickerControl.sourceType = UIImagePickerControllerSourceType.Camera
                pickerControl.delegate = self
                dispatch_async(dispatch_get_main_queue(), {
                    self.controller.presentViewController(pickerControl, animated: true, completion:{
                        NSLog("已打开摄像头")
                    })
                })
                self.token=token
            }else{
                NSLog("当前设备不支持摄像头")
            }
            
        }
    }
    
    //已完成拍照
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        //异步上传
        dispatch_async(dispatch_get_global_queue(0, 0), {
            NSLog("正在上传照片")
            var resulrtimage=image.waterMarkedImage(WATERMARK_VAL)
            let data=UIImageJPEGRepresentation(resulrtimage, COMPRESS_VAL)!
            resulrtimage=UIImage(data: data)!
            let fm=NSFileManager.defaultManager()
            if fm.isDeletableFileAtPath(NSTemporaryDirectory()+"pic.jpg"){
                NSLog("删除旧照片")
                try? fm.removeItemAtPath(TEMPFILE_URL)
            }
            data.writeToFile(TEMPFILE_URL, atomically: true)
            
            let fileUrl = NSURL(fileURLWithPath: TEMPFILE_URL)
            do {
                let opt = try HTTP.POST(BASE_URL+"user/uploadcard", parameters: ["token": self.token!, "file": Upload(fileUrl: fileUrl)])
                opt.start { response in
                    self.hasRespond(response)
                }
            } catch let error {
                NSLog("上传照片遇到问题：%@","\(error)")
            }
            self.token=nil
        })
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //已完成上传
    func hasRespond(resp:Response){
        NSLog("照片已上传成功")
        //json
        if let json=try? NSJSONSerialization.JSONObjectWithData(resp.data, options: NSJSONReadingOptions.MutableContainers){
                //回传图片url
                if let url=json["obj"]{
                    dispatch_async(dispatch_get_main_queue(), {
                        NSLog("回传照片地址：%@","\(url!)")
                        let jsFunc=self.jsContext.objectForKeyedSubscript("setImg")
                        jsFunc?.callWithArguments([url!])
                    })
                }
        }
    }
}
