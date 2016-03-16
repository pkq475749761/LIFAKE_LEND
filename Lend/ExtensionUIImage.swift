//
//  WaterMarkUtil.swift
//  Lend
//  水印
//  Created by alexlee on 16/3/16.
//  Copyright © 2016年 bird. All rights reserved.
//

import UIKit

extension UIImage{
    
    //水印位置枚举
    enum WaterMarkCorner{
        case TopLeft
        case TopRight
        case BottomLeft
        case BottomRight
    }
    
    //添加水印方法
    func waterMarkedImage(waterMarkText:String, corner:WaterMarkCorner = .BottomRight,
        margin:CGPoint = CGPoint(x: 20, y: 20), waterMarkTextColor:UIColor = UIColor.whiteColor(),
        waterMarkTextFont:UIFont = UIFont.systemFontOfSize(80),
        backgroundColor:UIColor = UIColor.clearColor()) -> UIImage{
            
            let textAttributes = [NSForegroundColorAttributeName:waterMarkTextColor,
                NSFontAttributeName:waterMarkTextFont]
            let textSize = NSString(string: waterMarkText).sizeWithAttributes(textAttributes)
            var textFrame = CGRectMake(0, 0, textSize.width, textSize.height)
            
            let imageSize = self.size
            switch corner{
            case .TopLeft:
                textFrame.origin = margin
            case .TopRight:
                textFrame.origin = CGPoint(x: imageSize.width - textSize.width - margin.x, y: margin.y)
            case .BottomLeft:
                textFrame.origin = CGPoint(x: margin.x, y: imageSize.height - textSize.height - margin.y)
            case .BottomRight:
                textFrame.origin = CGPoint(x: imageSize.width - textSize.width - margin.x,
                    y: imageSize.height - textSize.height - margin.y)
            }
            
            // 开始给图片添加文字水印
            UIGraphicsBeginImageContext(imageSize)
            self.drawInRect(CGRectMake(0, 0, imageSize.width, imageSize.height))
            NSString(string: waterMarkText).drawInRect(textFrame, withAttributes: textAttributes)
            
            let waterMarkedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            
            return waterMarkedImage
    }
}