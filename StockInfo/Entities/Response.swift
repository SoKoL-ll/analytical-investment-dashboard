//
//  Response.swift
//  StockInfo
//
//  Created by Alexander on 27.03.2024.
//

import Foundation

struct StockIndicatorsResponse: Decodable {
    let message: String
    let shortName: String
    let fullName: String
    let price: Double
    let items: [String: IndicatorInfo]
}

struct IndicatorInfo: Decodable {
    let value: Double?
    let postfix: String
    let name: String
    let description: String
    let verdict: Double?
}
