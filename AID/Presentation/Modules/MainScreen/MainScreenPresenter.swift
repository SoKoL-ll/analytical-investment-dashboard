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
        NetworkManager.shared.getStocks(with: "profitability") { [weak self] result in
            guard let self = self else {
                return
            }
        
            switch result {
            case .success(let stocks):
                let companies = stocks.map { $0.ticker }
                self.view?.setContent(companies: Array(companies.prefix(11)))
            case .failure(let error):
                print(error)
            }
        }
    }

    // Вызывается при нажатии на какую-либо компанию
    func openInfoAboutCompany(companyName: String) {
        print("\(companyName) did taped")
    }
}
