//
//  LendUITests.swift
//  LendUITests
//
//  Created by alexlee on 16/3/16.
//  Copyright © 2016年 bird. All rights reserved.
//

import XCTest

class LendUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        
        let app = XCUIApplication()
        let element = app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element
        element.tap()
        app.textFields["输入手机号码"].tap()
        app.textFields["输入手机号码"]
        app.secureTextFields["输入密码"].tap()
        
        let moreNumbersKey = app.keys["more, numbers"]
        moreNumbersKey.tap()
        moreNumbersKey.tap()
        app.secureTextFields["输入密码"]
        app.textFields["验证码"].tap()
        app.textFields["验证码"]
        element.tap()
        element.tap()
        element.tap()
        element.tap()
        element.tap()
        app.staticTexts["新增"].tap()
        app.textFields["请从通讯录选择联系人"].tap()
        app.tables.staticTexts["陈嘉敏"].tap()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}
