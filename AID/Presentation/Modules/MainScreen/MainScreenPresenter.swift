//
//  MainScreenPresenter.swift
//  AID
//
//  Created by Alexandr Sokolov on 23.03.2024.
//

import Foundation
import UIKit

protocol MainScreenPresenterDelegate: AnyObject {
    func launchData()
    func openInfoAboutCompany(companyName: String)
}

class MainScreenPresenter: MainScreenPresenterDelegate {
    weak var view: MainViewControllerDelegate?

    init(view: MainViewControllerDelegate) {
        self.view = view
    }

    func launchData() {
        view?.setContent()
    }

    // Вызывается при нажатии на какую-либо компанию
    func openInfoAboutCompany(companyName: String) {
        print("\(companyName) did taped")
    }
}
