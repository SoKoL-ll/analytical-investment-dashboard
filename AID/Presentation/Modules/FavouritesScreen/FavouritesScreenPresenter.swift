//
//  FavouritesScreenPresenter.swift
//  AID
//
//  Created by Alexandr Sokolov on 26.03.2024.
//

import Foundation

protocol FavouritesScreenPresenterProtocol: AnyObject {
    func launchData()
    func openInfoAboutCompany(companyName: String)
    func companyInFavourites(companyName: String) -> Bool
    func deleteFromFavourites(companyName: String)
}

class FavouritesScreenPresenter: FavouritesScreenPresenterProtocol {
    weak var view: FavouritesViewControllerProtocol?

    func deleteFromFavourites(companyName: String) {
        var favourites = Set(UserDefaults.standard.stringArray(forKey: "favourites") ?? [])
        favourites.remove(companyName)
        UserDefaults.standard.setValue(Array(favourites), forKey: "favourites")
    }

    init(view: FavouritesViewControllerProtocol) {
        self.view = view
    }

    func companyInFavourites(companyName: String) -> Bool {
        let favourites = Set(UserDefaults.standard.stringArray(forKey: "favourites") ?? [])

        return favourites.contains(companyName)
    }

    func launchData() {
        let array = UserDefaults.standard.stringArray(forKey: "favourites") ?? []
        
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
                var resultInfo = PageInfo()
                resultInfo.metricType = infoType
                
                var favouritesValues = [String: (Double, Double)]()
                for company in array {
                    for stock in stocks.0 where stock.ticker == company {
                        favouritesValues[company] = (Constants.constantForWeightFavourites, stock.indicator.value ?? 0)
                    }
                }

                resultInfo.tickers = favouritesValues
                
                self.view?.setContent(pageInfo: resultInfo)
            case .failure(let error):
                print(error)
            }
        }
    }

    func openInfoAboutCompany(companyName: String) {
        view?.pushCompanyDetailsViewController(companyName: companyName)
    }
}
