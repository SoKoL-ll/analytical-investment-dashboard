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
    func setContent(pagesInfo: [AID.PageInfo]) {}
    
    func pushCompanyDetailsViewController(companyName: String) {}
    
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

    class MockView: FavouritesViewControllerProtocol {
        var contentSet = false
        var pushedCompanyName: String?

        func setContent(pageInfo: PageInfo) {
            contentSet = true
        }

        func pushCompanyDetailsViewController(companyName: String) {
            pushedCompanyName = companyName
        }
    }

    var presenter: FavouritesScreenPresenter!
    var mockView: MockView!

    override func setUpWithError() throws {
        mockView = MockView()
        presenter = FavouritesScreenPresenter(view: mockView)
    }

    override func tearDownWithError() throws {
        mockView = nil
        presenter = nil
    }

    func testDeleteFromFavourites() throws {
        UserDefaults.standard.set(["Company1", "Company2"], forKey: "favourites")

        presenter.deleteFromFavourites(companyName: "Company1")

        XCTAssertEqual(UserDefaults.standard.stringArray(forKey: "favourites") ?? [], ["Company2"])
    }

    func testCompanyInFavourites() throws {
        UserDefaults.standard.set(["Company1", "Company2"], forKey: "favourites")

        let company1InFavourites = presenter.companyInFavourites(companyName: "Company1")
        let company3InFavourites = presenter.companyInFavourites(companyName: "Company3")

        XCTAssertTrue(company1InFavourites)
        XCTAssertFalse(company3InFavourites)
    }
}
