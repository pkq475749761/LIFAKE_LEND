//
//  ContactPicker.swift
//  Lend
//  选取联系人
//  Created by alexlee on 16/3/16.
//  Copyright © 2016年 bird. All rights reserved.
//

import Foundation
import AddressBookUI
import JavaScriptCore

class ContactPicker:NSObject,ABPeoplePickerNavigationControllerDelegate{
    let controller:WebViewController
    let jsContext:JSContext
    
    init(controller:WebViewController,jsContext:JSContext){
        self.controller=controller
        self.jsContext=jsContext
    }
    
    //开启联系人列表
    func openContactList(){
        NSLog("正在打开通讯录")
        let abcontroll=ABPeoplePickerNavigationController()
        abcontroll.peoplePickerDelegate=self
        abcontroll.predicateForSelectionOfProperty=nil
        abcontroll.displayedProperties=[NSNumber.init(int:kABPersonPhoneProperty)]
        controller.presentViewController(abcontroll, animated: true, completion: nil)
    }
    
    //选择联系人
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController, didSelectPerson person: ABRecord, property: ABPropertyID, identifier: ABMultiValueIdentifier) {
        NSLog("正在获取联系人信息")
        let nums:ABMutableMultiValueRef?=ABRecordCopyValue(person, property).takeRetainedValue()
        let lastName = ABRecordCopyValue(person, kABPersonLastNameProperty)?
            .takeRetainedValue() as! String? ?? ""
        let firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty)?
            .takeRetainedValue() as! String? ?? ""
        let name=lastName+firstName
        if nums != nil{
            let i=CFIndex(identifier)
            returnContact(ABMultiValueCopyValueAtIndex(nums, i).takeRetainedValue() as! String,name: name)
        }
    }
    
    //返回所选结果
    func returnContact(contact:String,name:String){
        NSLog("回传联系人信息：%@,%@",name,contact)
        let jsFunc=jsContext.objectForKeyedSubscript("returnContact")
        jsFunc?.callWithArguments([contact,name])
    }
    
}