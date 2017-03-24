//
//  MonkeyForOCUIMonkeyTests.swift
//  MonkeyForOCUIMonkeyTests
//
//  Created by gerry on 2017/3/24.
//  Copyright © 2017年 Doray. All rights reserved.
//

import XCTest

import SwiftMonkey

class MonkeyForOCUIMonkeyTests: XCTestCase {
    
    override func setUp() {
        
        super.setUp()
        
        XCUIApplication().launch()
        
    }
    
    override func tearDown() {
        
        super.tearDown()
        
    }
    
    func testMonkey() {
        
        let application = XCUIApplication()
        
        _ = application.descendants(matching: .any).element(boundBy: 0).frame
        
        let monkey = Monkey(frame: application.frame)
        
        monkey.addDefaultXCTestPrivateActions()
        
        monkey.addXCTestTapAlertAction(interval: 100, application: application)
        
        monkey.monkeyAround()
        
    }
    
}
