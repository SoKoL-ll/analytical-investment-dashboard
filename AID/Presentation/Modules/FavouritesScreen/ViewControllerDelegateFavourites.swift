//
//  ViewControllerDelegateFavourites.swift
//  AID
//
//  Created by Alexandr Sokolov on 27.03.2024.
//

import Foundation

protocol ViewControllerDelegateFavourites: AnyObject {
    func didCopmanyInFavourites(companyName: String) -> Bool
    func addToFavourites(companyName: String)
    func deleteFromFavourites(companyName: String) -> Bool
}

extension ViewControllerDelegateFavourites {
    func addToFavourites(companyName: String) {}
}
