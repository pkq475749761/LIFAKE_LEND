//
//  ContactUploader.swift
//  Lend
//  上传联系人
//  Created by alexlee on 16/3/24.
//  Copyright © 2016年 bird. All rights reserved.
//

import Foundation
import AddressBook
import AddressBookUI

class ContactUploader:NSObject{
    
    var addressBook:ABAddressBookRef?
    var result=""
    
    //上传联系人
    func uploadAll(token:String){
        result=""
        getAllContacts()
        
        NSLog("正在上传联系人")
        let params:Dictionary<String,String> = ["token": "\(token)","nums":result]
        do {
            let opt = try HTTP.POST(BASE_URL+"Contact/upload", parameters: params)
            opt.start {response in
                NSLog("上传联系人成功")
            }
        } catch {
            NSLog("上传联系人失败")
        }
        
    }
    
    //获取所有联系人
    func getAllContacts(){
        
        var error:Unmanaged<CFErrorRef>?
        addressBook = ABAddressBookCreateWithOptions(nil, &error).takeRetainedValue()
        
        //发出授权信息
        NSLog("正在获取所有联系人")
        let sysAddressBookStatus = ABAddressBookGetAuthorizationStatus()
        if (sysAddressBookStatus == ABAuthorizationStatus.NotDetermined) {
            //addressBook = extractABAddressBookRef(ABAddressBookCreateWithOptions(nil, &errorRef))
            ABAddressBookRequestAccessWithCompletion(addressBook, { success, error in
                if success {
                    //获取并遍历所有联系人记录
                    self.readRecords();
                }
                else {
                    NSLog("获取所有联系人失败")
                }
            })
        }
        else if (sysAddressBookStatus == ABAuthorizationStatus.Denied ||
            sysAddressBookStatus == ABAuthorizationStatus.Restricted) {
            NSLog("没有权限读取联系人")
        }
        else if (sysAddressBookStatus == ABAuthorizationStatus.Authorized) {
            //获取并遍历所有联系人记录
            readRecords();
        }
    }
    
    //拼接联系人信息
    func readRecords(){
        NSLog("正在读取联系人信息")
        let sysContacts:NSArray = ABAddressBookCopyArrayOfAllPeople(addressBook)
            .takeRetainedValue() as NSArray
        
        for contact in sysContacts {
            //获取姓
            let lastName = ABRecordCopyValue(contact, kABPersonLastNameProperty)?
                .takeRetainedValue() as! String? ?? ""
            //获取名
            let firstName = ABRecordCopyValue(contact, kABPersonFirstNameProperty)?
                .takeRetainedValue() as! String? ?? ""
            let name=lastName+firstName
            if name.isEmpty || name==""{
                continue
            }
            
            let nums:ABMutableMultiValueRef?=ABRecordCopyValue(contact, kABPersonPhoneProperty).takeRetainedValue()
            if nums != nil{
                for i in 0 ..< ABMultiValueGetCount(nums){
                    var num=ABMultiValueCopyValueAtIndex(nums, CFIndex(i)).takeRetainedValue() as! String
                    let range=num.rangeOfString("+86 ")
                    if range != nil{
                        num.removeRange(range!)
                    }
                    let range2=num.rangeOfString("+")
                    if range2 != nil{
                        num.removeRange(range2!)
                    }
                    let range3=num.rangeOfString(" ")
                    if range3 != nil{
                        num.removeRange(range3!)
                    }
                    result+=name+"@"+num+","
                }
            }
        }
        NSLog("读取完成，联系人信息：\(result)")
    }
    
}
