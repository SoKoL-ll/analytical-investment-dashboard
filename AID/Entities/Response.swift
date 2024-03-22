//
//  Response.swift
//  AID
//
//  Created by Alexander on 21.03.2024.
//

import Foundation

struct StockResponse: Decodable {
    let message: String
    let items: [String: Price]
    let postfix: String
    let updatedAt: String
}

struct StockPricesResponse: Decodable {
    let message: String
    let items: [PriceInfo]
}

struct StockIndicatorsResponse: Decodable {
    let message: String
    let tickerFullName: String
    let items: [String: IndicatorInfo]
}

struct IndicatorInfo: Decodable {
    let value: Double
    let postfix: String
    let description: String
    let shouldBuy: Bool
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
