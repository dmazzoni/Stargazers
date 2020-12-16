//
//  StargazerListUITests.swift
//  StargazersUITests
//
//  Created by Davide Mazzoni on 12/12/20.
//

import XCTest

class StargazerListUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }

    func testSearchButtonIsInitiallyDisabled() {
        
        let app = XCUIApplication()
        app.launch()

        let button = app.buttons[StargazerListAxIdentifiers.searchButton.rawValue]
        
        XCTAssertTrue(button.waitForExistence(timeout: 1.0))
        XCTAssertFalse(button.isEnabled)
    }
    
    func testSearchButtonIsEnabledWhenFormIsFilled() {
        
        let app = XCUIApplication()
        app.launch()
        
        let ownerField = app.textFields[RepositoryFormAxIdentifiers.owner.rawValue]
        let nameField = app.textFields[RepositoryFormAxIdentifiers.name.rawValue]
        
        XCTAssertTrue(ownerField.waitForExistence(timeout: 1.0))
        XCTAssertTrue(nameField.exists)
        
        ownerField.tap()
        ownerField.typeText("owner")
        
        nameField.tap()
        nameField.typeText("name")
        
        let button = app.buttons[StargazerListAxIdentifiers.searchButton.rawValue]
        XCTAssertTrue(button.isEnabled)
    }
    
    func testClearButtonResetsField() {
        
        let app = XCUIApplication()
        app.launch()
        
        let field = app.textFields[RepositoryFormAxIdentifiers.owner.rawValue]
        let clearButton = app.buttons[RepositoryFormAxIdentifiers.owner.rawValue]
        XCTAssertTrue(field.waitForExistence(timeout: 1.0))
        
        let expectedText = "owner"
        field.tap()
        field.typeText(expectedText)
        XCTAssertEqual(expectedText, field.value as? String)
        
        clearButton.tap()
        
        XCTAssertEqual(field.placeholderValue, field.value as? String)
    }
}
