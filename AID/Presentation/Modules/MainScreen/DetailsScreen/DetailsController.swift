//
//  DetailsViewController.swift
//  SwiftCharts
//
//  Created by Михаил Симаков on 24.03.2024.
//

import Foundation
import Observation
import SwiftUI

enum LoadingState {
    case fetching
    case loaded
    case error(Error)
}

struct IndicatorVerdictInfo {
    let color: Color
    let symbolSystemName: String?
    let description: String
}

final class DetailsController: ObservableObject {
    var ticker: String
    
    @Published var tickerShortName: String?
    @Published var tickerFullName: String?
    
    @Published var priceChartTimeDelta: TimeDelta = .month
    @Published var priceChartData: [TimeDelta: [ChartData]] = [:]
    @Published var priceChartLoadingState: LoadingState = .fetching
    
    @Published var indicators: [Indicator] = []
    @Published var indicatorsLoadingState: LoadingState = .fetching
    
    @Published private(set) var isFavourite: Bool = false
    
    var indicatorsForView: [Indicator] {
        return indicators.filter { $0.value != nil }
            .sorted { $0.type < $1.type }
    }
    
    struct ProsConsData {
        let pros: Int
        let cons: Int
        
        init(pros: Int = 0, cons: Int = 0) {
            self.pros = pros
            self.cons = cons
        }
        
        var prosPercentage: Double {
            if pros + cons == 0 {
                return 0
            }
            
            return Double(pros) / Double(pros + cons)
        }
        
        var consPercentage: Double {
            if pros + cons == 0 {
                return 0
            }
            
            return Double(cons) / Double(pros + cons)
        }
        
        var verdict: Double? {
            if pros + cons < 5 {
                return nil
            }
            
            return Double(pros - cons) / Double(pros + cons)
        }
    }
    
    var tickerProsConsData: ProsConsData = ProsConsData()
    
    init(ticker: String) {
        self.ticker = ticker
        loadFavouriteState()
    }
    
    // returns system name of verdict image and color for that image
    static func getVerdictViewInformation(_ verdict: Double?) -> IndicatorVerdictInfo {
        guard let verdict else {
            return .init(color: .secondary, symbolSystemName: nil, description: String(localized: "Not enough data"))
        }
        
        if verdict < -Constants.neutralVerdictThreshold {
            return .init(color: Color(.red), symbolSystemName: "minus", description: String(localized: "Should sell"))
        } else if verdict > Constants.neutralVerdictThreshold {
            return .init(color: Color(.green), symbolSystemName: "plus", description: String(localized: "Should buy"))
        }
        
        return .init(color: .secondary, symbolSystemName: "equal", description: String(localized: "Neutral"))
    }
    
    func loadFavouriteState() {
        let favourites = UserDefaults.standard.stringArray(forKey: "favourites") ?? []
        isFavourite = favourites.contains(ticker)
    }
    
    func updateProsConsData() {
        var prosCount = 0
        var consCount = 0
        
        for indicator in indicators {
            guard let verdict = indicator.verdict else {
                continue
            }
            
            if verdict < -Constants.neutralVerdictThreshold {
                consCount += 1
            } else if verdict > Constants.neutralVerdictThreshold {
                prosCount += 1
            }
        }
        
        tickerProsConsData = ProsConsData(pros: prosCount, cons: consCount)
    }
    
    func switchFavouriteState() {
        var favourites = Set(UserDefaults.standard.stringArray(forKey: "favourites") ?? [])
        
        if isFavourite {
            favourites.remove(ticker)
        } else {
            favourites.insert(ticker)
        }
        
        UserDefaults.standard.setValue(Array(favourites), forKey: "favourites")
        isFavourite.toggle()
    }
    
    func loadPriceChartData() {
        let delta = priceChartTimeDelta
        if self.priceChartData[delta] != nil {
            return
        }
        
        self.priceChartLoadingState = .fetching
        
        NetworkManager.shared.getStockPrices(ticker, in: delta, completion: { [weak self, delta] response in
            guard let self = self else {
                return
            }
            
            switch response {
            case .success(let data):
                self.priceChartData[delta] = data
                
                if self.priceChartTimeDelta == delta {
                    self.priceChartLoadingState = .loaded
                }
            case .failure(let error):
                self.priceChartLoadingState = .error(error)
            }
        })
    }
    
    func loadIndicators() {
        if !indicators.isEmpty {
            return
        }
        
        indicatorsLoadingState = .fetching
        
        NetworkManager.shared.getStockIndicators(ticker, completion: { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let stockInfo):
                self.tickerShortName = stockInfo.name
                self.tickerFullName = stockInfo.description
                self.indicators = stockInfo.indicators
                self.indicatorsLoadingState = .loaded
                
                self.updateProsConsData()
            case .failure(let error):
                self.indicatorsLoadingState = .error(error)
            }
        })
    }
    
    func reloadDetails() {
        priceChartData.removeAll()
        loadPriceChartData()
    }
    
    func reloadIndicators() {
        indicators.removeAll()
        loadIndicators()
    }
}

private extension DetailsController {
    struct Constants {
        static let neutralVerdictThreshold: Double = 0.2
    }
}
