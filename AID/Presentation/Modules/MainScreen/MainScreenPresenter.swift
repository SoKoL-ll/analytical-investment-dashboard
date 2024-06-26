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

        let indexInfoType = UserDefaults.standard.integer(forKey: "metricIndex")

        var infoType = "profitability"

        NetworkManager.shared.getCategories { result in
            switch result {
            case .success(let categories):
                infoType = categories[indexInfoType]
            case .failure(let error):
                print(error)
            }
        }

        NetworkManager.shared.getStocks(with: infoType) { [weak self] result in
            guard let self = self else {
                return
            }
        
            switch result {
            case .success(let stocks):
                var resultInfo = [PageInfo]()
                for index in stocks.1 {
                    let tickers = index.tickers
                    var tickersForResult = [String: (Double, Double)]()

                    for ticker in tickers {
                        for stock in stocks.0 where stock.ticker == ticker.key {
                            tickersForResult[ticker.key] = (ticker.value, stock.indicator.value ?? 0)
                        }
                    }
                    
                    resultInfo.append(PageInfo(
                        shortName: index.shortName,
                        fullName: index.fullName,
                        metricType: infoType,
                        tickers: tickersForResult
                    ))
                }

                self.view?.setContent(pagesInfo: resultInfo)
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
