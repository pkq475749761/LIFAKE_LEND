//
//  GlobleValues.swift
//  Lend
//  全局变量
//  Created by alexlee on 16/3/28.
//  Copyright © 2016年 bird. All rights reserved.
//

import UIKit

//url
public let BASE_URL="http://192.168.9.111:28880/"//域名
public let BASE_URL_INDEX=BASE_URL+"index?client=2"//首页地址

//图片
public let COMPRESS_VAL:CGFloat=0.5//压缩系数
public let WATERMARK_VAL="河马大叔"//水印文字

//异常
public let ERROR_PIC_URL=NSBundle.mainBundle().pathForResource("error", ofType: "jpg")!
public let ERROR_PAGE_URL=NSBundle.mainBundle().pathForResource("error", ofType: "html")!