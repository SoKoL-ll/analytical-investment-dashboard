//
//  AIDError.swift
//  AID
//
//  Created by Alexander on 20.03.2024.
//

import Foundation

enum AIDError: String, Error {
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server was invalid. Try again"
    case unableToComplete = "Unable to complete your request. Please check your internet connection."
    case unableToFavorite = "There was an error favoriting this stock. Please try again."
    case alreadyInFavorites = "You've already favorited this stock. You must REALLY like it!"
}
