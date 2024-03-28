//
//  Response.swift
//  AID
//
//  Created by Alexander on 21.03.2024.
//

import Foundation

struct StockResponse: Decodable {
    let message: String
    let tickers: [String: Price]
    let postfix: String
    let updatedAt: String
}

struct StockPricesResponse: Decodable {
    let message: String
    let items: [PriceInfo]
}

struct StockIndicatorsResponse: Decodable {
    let message: String
    let shortName: String
    let fullName: String
    let price: Double
    let items: [String: IndicatorInfo]
}

struct CategoriesResponse: Decodable {
    let message: String
    let categories: [String]
}

struct IndicatorInfo: Decodable {
    let value: Double?
    let postfix: String
    let name: String
    let description: String
    let verdict: Double?
}

struct Price: Decodable {
    let value: Double?
}

struct PriceInfo: Decodable {
    let open: Double
    let close: Double
    let high: Double
    let low: Double
    let begin: String
    let end: String
}
