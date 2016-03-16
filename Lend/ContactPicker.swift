//
//  ContactPicker.swift
//  Lend
//
//  Created by alexlee on 16/3/16.
//  Copyright © 2016年 bird. All rights reserved.
//

import Foundation
import AddressBookUI

class Contact:NSObject,ABPeoplePickerNavigationControllerDelegate{
    let controller:WebViewController
    
    init(controller:WebViewController){
        self.controller=controller
    }
    
    func openContactList(){
        print("open")
        let abcontroll=ABPeoplePickerNavigationController()
        abcontroll.peoplePickerDelegate=self
        abcontroll.predicateForSelectionOfProperty=nil
        controller.presentViewController(abcontroll, animated: true, completion: nil)
    }
    
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController, didSelectPerson person:
        ABRecord) {
            print("select a person")
            let fn=String(ABRecordCopyValue(person, kABPersonFirstNameProperty).takeRetainedValue())
            let ln=String(ABRecordCopyValue(person, kABPersonLastNameProperty).takeRetainedValue())
    }
}