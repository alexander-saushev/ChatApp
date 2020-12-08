//
//  ChatAppUITests.swift
//  ChatAppUITests
//
//  Created by Александр Саушев on 02.12.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import XCTest

class ChatAppUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they
        // run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testProfile() throws {
        let app = XCUIApplication()
        app.launch()
        
        let profileButton = app.navigationBars.buttons["OpenProfileButton"].firstMatch
        let profileButtonExistens = profileButton.waitForExistence(timeout: 5.0)
        
        XCTAssertTrue(profileButtonExistens)
        profileButton.tap()
        
        let nameTextField = app.textFields["NameTextField"].firstMatch
        let nameTextFieldExistens = nameTextField.waitForExistence(timeout: 5.0)
        let bioTextView = app.textViews["BioTextView"].firstMatch
        let bioTextViewExistens = bioTextView.waitForExistence(timeout: 5.0)
        
        XCTAssertTrue(nameTextFieldExistens)
        XCTAssertTrue(bioTextViewExistens)

    }
    
}
