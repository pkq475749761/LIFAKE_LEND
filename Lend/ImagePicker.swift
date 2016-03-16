//
//  ImagePicker.swift
//  Lend
//  拍照
//  Created by alexlee on 16/3/16.
//  Copyright © 2016年 bird. All rights reserved.
//

import UIKit
import MobileCoreServices

class ImagePicker: NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    let controller:WebViewController
    
    init(controller:WebViewController){
        self.controller=controller
    }
    
    
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            
            //根据指定的SourceType来获取该SourceType下可以用的媒体类型，返回的是一个数组
            let mediaTypeArr:NSArray = UIImagePickerController.availableMediaTypesForSourceType(UIImagePickerControllerSourceType.Camera)!
            if mediaTypeArr.containsObject(kUTTypeImage){
                
                //创建一个UIImagePickerController
                let pickerControl = UIImagePickerController()
                //必须，第一步，设置SourceType，Camera表示相机
                pickerControl.sourceType = UIImagePickerControllerSourceType.Camera
                //必须，第二步，设置相机的View中可以使用的媒体类型，这里直接使用上面的mediaTypeArr,它包含了视频和图像
                //                pickerControl.mediaTypes = mediaTypeArr as [AnyObject]
                //必须，第三步，设置delegate：UIImagePickerControllerDelegate,UINavigationControllerDelegate
                //这两个必须都写上，可以进入头文件查看到
                pickerControl.delegate = self
                
                //必须，第四步，显示
                controller.presentViewController(pickerControl, animated: true, completion:{
                    print("completion")
                })
            }else{
                print("当前设备不支持摄像头")
            }
            
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        print("has taken pic")
        var resulrtimage=image.waterMarkedImage("河马大叔水印")
        
        resulrtimage=UIImage(data: UIImageJPEGRepresentation(resulrtimage, 1.0)!)!
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}
