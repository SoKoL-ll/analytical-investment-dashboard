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
        self.view?.setContent(companies: UserDefaults.standard.stringArray(forKey: "favourites") ?? [])
    }

    // Вызывается при нажатии на какую-либо компанию
    func openInfoAboutCompany(companyName: String) {
        print("\(companyName) did taped")
    }
}
