//
//  AIDUITests.swift
//  AIDUITests
//
//  Created by Alexandr Sokolov on 27.03.2024.
//

import XCTest

final class AIDUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
        try super.tearDownWithError()
    }

    func testTabBarItems() throws {
        // Access tab bars
        let tabBar = app.tabBars.element
        XCTAssertTrue(tabBar.exists)

        // Access tab bar items
        let mainTab = tabBar.buttons[String(localized: "Main")]
        let accountTab = tabBar.buttons[String(localized: "Profile")]
        let favouritesTab = tabBar.buttons[String(localized: "Favourite")]

        // Validate tab bar items
        XCTAssertTrue(mainTab.exists)
        XCTAssertTrue(accountTab.exists)
        XCTAssertTrue(favouritesTab.exists)

        favouritesTab.tap()
        XCTAssertTrue(app.scrollViews.element.waitForExistence(timeout: 5))
        XCTAssertTrue(app.scrollViews.element.exists)
        
        accountTab.tap()
        XCTAssertTrue(app.scrollViews.element.waitForExistence(timeout: 5))
        XCTAssertTrue(app.scrollViews.element.exists)
    }
}
