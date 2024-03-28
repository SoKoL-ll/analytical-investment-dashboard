//
//  AIDUnitTests.swift
//  AIDUnitTests
//
//  Created by Alexandr Sokolov on 27.03.2024.
//

import XCTest
@testable import AID

final class MainScreenPresenterTests: XCTestCase {

    var presenter: MainScreenPresenter!
    var mockView: MockMainViewController!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockView = MockMainViewController()
        presenter = MainScreenPresenter(view: mockView)
    }

    override func tearDownWithError() throws {
        mockView = nil
        presenter = nil
        try super.tearDownWithError()
    }

    func testCompanyInFavourites() {
        UserDefaults.standard.set(["Company1", "Company2"], forKey: "favourites")

        XCTAssertTrue(presenter.companyInFavourites(companyName: "Company1"))
        XCTAssertFalse(presenter.companyInFavourites(companyName: "Company3"))
    }

    func testAddToFavourites() {
        presenter.addToFavourites(companyName: "NewCompany")
        XCTAssertTrue(presenter.companyInFavourites(companyName: "NewCompany"))
    }

    func testDeleteFromFavourites() {
        UserDefaults.standard.set(["Company1", "Company2"], forKey: "favourites")

        presenter.deleteFromFavourites(companyName: "Company1")
        XCTAssertFalse(presenter.companyInFavourites(companyName: "Company1"))
    }
}

// Mock класс MainViewController для тестирования
class MockMainViewController: MainViewControllerProtocol {
    var expectation: XCTestExpectation?
    var companiesSet: [String]?
    var errorLogged = false

    func setContent(companies: [String]) {
        companiesSet = companies
        expectation?.fulfill()
    }

    func logError() {
        errorLogged = true
    }
}

final class FavouritesScreenPresenterTests: XCTestCase {

    var presenter: FavouritesScreenPresenter!
    var mockView: MockFavouritesViewController!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockView = MockFavouritesViewController()
        presenter = FavouritesScreenPresenter(view: mockView)
    }

    override func tearDownWithError() throws {
        mockView = nil
        presenter = nil
        try super.tearDownWithError()
    }

    func testCompanyInFavourites() {
        UserDefaults.standard.set(["Company1", "Company2"], forKey: "favourites")

        XCTAssertTrue(presenter.companyInFavourites(companyName: "Company1"))
        XCTAssertFalse(presenter.companyInFavourites(companyName: "Company3"))

        UserDefaults.standard.set([], forKey: "favourites")
    }

    func testDeleteFromFavourites() {
        UserDefaults.standard.set(["Company1", "Company2"], forKey: "favourites")

        presenter.deleteFromFavourites(companyName: "Company1")
        XCTAssertFalse(presenter.companyInFavourites(companyName: "Company1"))

        UserDefaults.standard.set([], forKey: "favourites")
    }

    func testLaunchData() {
        let companies = ["Company1", "Company2"]
        UserDefaults.standard.set(companies, forKey: "favourites")

        presenter.launchData()
        XCTAssertEqual(mockView.companiesSet, companies)

        UserDefaults.standard.set([], forKey: "favourites")
    }
}

// Mock класс FavouritesViewController для тестирования
class MockFavouritesViewController: FavouritesViewControllerProtocol {
    var companiesSet: [String]?

    func setContent(companies: [String]) {
        companiesSet = companies
    }
}
