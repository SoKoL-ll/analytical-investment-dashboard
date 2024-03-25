//
//  MainScreenPresenter.swift
//  AID
//
//  Created by Alexandr Sokolov on 23.03.2024.
//

import Foundation
import UIKit

protocol MainScreenPresenterProtocol: AnyObject {
    func launchData()
    func openInfoAboutCompany(companyName: String)
}

class MainScreenPresenter: MainScreenPresenterProtocol {
    weak var view: MainViewControllerProtocol?

    init(view: MainViewControllerProtocol) {
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
