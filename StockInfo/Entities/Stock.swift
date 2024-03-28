//
//  Stock.swift
//  StockInfo
//
//  Created by Alexander on 27.03.2024.
//

import SwiftUI

struct StockInfoWidgetModel {
    let ticker: String
    let fullName: String
    let price: String
    let isPositive: Bool
    let indicator: String
    let indicatorPostfix: String
}

struct StockInfoWidgetModelNew {
    let model: StockInfoWidgetModel
    let image: Image
}
