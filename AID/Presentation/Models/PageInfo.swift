//
//  BubbleInfo.swift
//  AID
//
//  Created by Alexandr Sokolov on 28.03.2024.
//

import Foundation

struct PageInfo {
    var shortName: String
    var fullName: String
    var metricType: String
    var tickers: [String: (Double, Double)]

    init(shortName: String = "", fullName: String = "", metricType: String = "", tickers: [String: (Double, Double)] = [:]) {
        self.shortName = shortName
        self.fullName = fullName
        self.metricType = metricType
        self.tickers = tickers
    }
}
