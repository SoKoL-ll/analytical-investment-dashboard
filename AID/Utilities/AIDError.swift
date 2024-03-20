//
//  AIDError.swift
//  AID
//
//  Created by Alexander on 20.03.2024.
//

import Foundation

enum AIDError: String, Error {
    
    case invalidUsername    = "This username created an Invalid request. Please try again."
    case unableToComplete   = "Unable to complete your request. Please check your internet connection."
    case invalidResponse    = "Invalid response from the server. Please try again."
    case invalidData        = "The data received from the server was invalid. Try again"
    case unableToFavorite   = "There was an error favoriting this user. Please try again."
    case alreadyInFavorites = "You've already favorited this user. You must REALLY like them!"
}
