//
//  ContactPicker.swift
//  Lend
//
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
    
    func openContactList(){
        let abcontroll=ABPeoplePickerNavigationController()
        abcontroll.peoplePickerDelegate=self
        abcontroll.predicateForSelectionOfProperty=nil
        abcontroll.displayedProperties=[NSNumber.init(int:kABPersonPhoneProperty)]
        controller.presentViewController(abcontroll, animated: true, completion: nil)
    }
    
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController, didSelectPerson person: ABRecord, property: ABPropertyID, identifier: ABMultiValueIdentifier) {
        let nums:ABMutableMultiValueRef?=ABRecordCopyValue(person, property).takeRetainedValue()
        if nums != nil{
            let i=CFIndex(identifier)
            returnContact(ABMultiValueCopyValueAtIndex(nums, i).takeRetainedValue() as! String)
            
        }
    }
    
    func returnContact(contact:String){
        print(contact)
        let jsFunc=jsContext.objectForKeyedSubscript("returnContact")
        jsFunc?.callWithArguments([contact])
    }
    
}