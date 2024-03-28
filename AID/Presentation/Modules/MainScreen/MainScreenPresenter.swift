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
    func companyInFavourites(companyName: String) -> Bool
    func addToFavourites(companyName: String)
    func deleteFromFavourites(companyName: String)
}

class MainScreenPresenter: MainScreenPresenterProtocol {
    func deleteFromFavourites(companyName: String) {
        var favourites = Set(UserDefaults.standard.stringArray(forKey: "favourites") ?? [])
        favourites.remove(companyName)
        UserDefaults.standard.setValue(Array(favourites), forKey: "favourites")
    }
    
    func addToFavourites(companyName: String) {
        var favourites = Set(UserDefaults.standard.stringArray(forKey: "favourites") ?? [])
        favourites.insert(companyName)
        UserDefaults.standard.setValue(Array(favourites), forKey: "favourites")
    }
    
    weak var view: MainViewControllerProtocol?

    init(view: MainViewControllerProtocol) {
        self.view = view
    }

    func companyInFavourites(companyName: String) -> Bool {
        let favourites = Set(UserDefaults.standard.stringArray(forKey: "favourites") ?? [])

        return favourites.contains(companyName)
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
        view?.pushCompanyDetailsViewController(companyName: companyName)
    }
}
