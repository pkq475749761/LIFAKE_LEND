//
//  ContactPicker.swift
//  Lend
//
//  Created by alexlee on 16/3/16.
//  Copyright © 2016年 bird. All rights reserved.
//

import Foundation
import AddressBookUI

class ContactPicker:NSObject,ABPeoplePickerNavigationControllerDelegate{
    let controller:WebViewController
    
    init(controller:WebViewController){
        self.controller=controller
    }
    
    func openContactList(){
        NSLog("openContact")
        let abcontroll=ABPeoplePickerNavigationController()
        abcontroll.peoplePickerDelegate=self
        abcontroll.predicateForSelectionOfProperty=nil
        controller.presentViewController(abcontroll, animated: true, completion: nil)
    }
    
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController, didSelectPerson person:
        ABRecord) {
            NSLog("select a person")
            let fn=String(ABRecordCopyValue(person, kABPersonFirstNameProperty).takeRetainedValue())
            let ln=String(ABRecordCopyValue(person, kABPersonLastNameProperty).takeRetainedValue())
            print(fn)
            print(ln)
    }
}