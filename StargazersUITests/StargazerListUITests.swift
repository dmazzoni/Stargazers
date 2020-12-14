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

    func testSearchButtonIsInitiallyDisabled() throws {
        
        let app = XCUIApplication()
        app.launch()

        let button = app.buttons[StargazerListAxIdentifiers.searchButton.rawValue]
        
        XCTAssertTrue(button.waitForExistence(timeout: 1.0))
        XCTAssertFalse(button.isEnabled)
    }
}
