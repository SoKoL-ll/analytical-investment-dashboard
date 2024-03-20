//
//  NetworkManager.swift
//  AID
//
//  Created by Alexander on 20.03.2024.
//

import Foundation

protocol NetworkManagerDescription {
    func getStocks(_ stockNames: [String], with indicatorType: IndicatorType) -> [Stock]
    func getStockIndicators(_ stockName: String) -> [Indicator]
    func getStockPrices(_ stockName: String, in timeDelta: TimeDelta) -> [ChartData]
}

class NetworkManager: NetworkManagerDescription {
    static let shared: NetworkManagerDescription = NetworkManager()
//    private let baseURL = "https://api.github.com/users/"
    
    private init() {}
    
    func getStocks(_ stockNames: [String] = [], with indicatorType: IndicatorType) -> [Stock] {
        
        return []
    }
    
    func getStockIndicators(_ stockName: String) -> [Indicator] {
        
        return []
    }
    
    func getStockPrices(_ stockName: String, in timeDelta: TimeDelta) -> [ChartData] {
        
        return []
    }
}
