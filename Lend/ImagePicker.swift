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
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            
            //根据指定的SourceType来获取该SourceType下可以用的媒体类型，返回的是一个数组
            let mediaTypeArr:NSArray = UIImagePickerController.availableMediaTypesForSourceType(UIImagePickerControllerSourceType.Camera)!
            if mediaTypeArr.containsObject(kUTTypeImage){
                
                //创建一个UIImagePickerController
                let pickerControl = UIImagePickerController()
                //必须，第一步，设置SourceType，Camera表示相机
                pickerControl.sourceType = UIImagePickerControllerSourceType.Camera
                //必须，第二步，设置相机的View中可以使用的媒体类型，这里直接使用上面的mediaTypeArr,它包含了视频和图像
                //                                pickerControl.mediaTypes = mediaTypeArr as [AnyObject]
                //必须，第三步，设置delegate：UIImagePickerControllerDelegate,UINavigationControllerDelegate
                //这两个必须都写上，可以进入头文件查看到
                pickerControl.delegate = self
                
                //必须，第四步，显示

                dispatch_async(dispatch_get_main_queue(), {
                    self.controller.presentViewController(pickerControl, animated: true,     completion:{
                        NSLog("completion")
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
                print("has taken pic")
                var resulrtimage=image.waterMarkedImage(WATERMARK_VAL)
                let data=UIImageJPEGRepresentation(resulrtimage, COMPRESS_VAL)!
                resulrtimage=UIImage(data: data)!
                let fm=NSFileManager.defaultManager()
//                fm.isDeletableFileAtPath(NSTemporaryDirectory()+"pic.jpg")
                try? fm.removeItemAtPath(TEMPFILE_URL)
                data.writeToFile(TEMPFILE_URL, atomically: true)
                print("file://"+TEMPFILE_URL)
                controller.webView.stringByEvaluatingJavaScriptFromString("document.getElementById('pic').src='file://\(TEMPFILE_URL)'")
        
                let fileUrl = NSURL(fileURLWithPath: TEMPFILE_URL)
                do {
                    let opt = try HTTP.POST(BASE_URL+"user/uploadcard", parameters: ["token": token!, "file": Upload(fileUrl: fileUrl)])
                    opt.start { response in
                        self.hasRespond(response)
                    }
                } catch let error {
                    print("got an error creating the request: \(error)")
                }
        
        token=nil
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //已完成上传
    func hasRespond(resp:Response){
        //json
        if let json=try? NSJSONSerialization.JSONObjectWithData(resp.data, options: NSJSONReadingOptions.MutableContainers){
                //回传图片url
                if let url=json["obj"]{
                    dispatch_async(dispatch_get_main_queue(), {
                        let jsFunc=self.jsContext.objectForKeyedSubscript("setImg")
                        jsFunc?.callWithArguments([url!])
                        print(url!)
                    })
                }
            
//            }
        }
    }
}
