//
//  Response.swift
//  AID
//
//  Created by Alexander on 21.03.2024.
//

import Foundation

struct StockResponse: Codable {
    let message: String
    let items: [String: Price]
}

struct StockPricesResponse: Codable {
    let message: String
    let items: [PriceInfo]
}

struct Price: Codable {
    let value: Double
}

struct PriceInfo: Codable {
    let value: Double
    let begin: String
    let end: String
}
