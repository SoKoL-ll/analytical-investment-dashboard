//
//  Stock.swift
//  AID
//
//  Created by Alexander on 20.03.2024.
//

import Foundation

struct Stock {
    let ticker: String
    let indicator: Indicator
}

struct Indicator {
    let type: IndicatorType
    let value: Double?
    let desciption: String?
    
    init(type: IndicatorType, value: Double? = nil, desciption: String? = nil) {
        self.type = type
        self.value = value
        self.desciption = desciption
    }
}

enum IndicatorType: String {
    case profitability, dividends, relativeDividends, ma5, ma10, ma20, ma50, ma100, ma200, ema5, ema10, ema20, ema50, ema100, ema200
    
    var description: String {
        switch self {
        case .profitability: return "profitability"
        case .dividends: return "dividends"
        case .relativeDividends: return "relative_dividends"
        case .ma5: return "ma5"
        case .ma10: return "ma10"
        case .ma20: return "ma20"
        case .ma50: return "ma50"
        case .ma100: return "ma100"
        case .ma200: return "ma200"
        case .ema5: return "ema5"
        case .ema10: return "ema10"
        case .ema20: return "ema20"
        case .ema50: return "ema50"
        case .ema100: return "ema100"
        case .ema200: return "ema200"
        }
    }
    
    static func from(description: String) -> IndicatorType? {
        switch description {
        case "profitability": return .profitability
        case "dividends": return .dividends
        case "relative_dividends": return .relativeDividends
        case "ma5": return .ma5
        case "ma10": return .ma10
        case "ma20": return .ma20
        case "ma50": return .ma50
        case "ma100": return .ma100
        case "ma200": return .ma20
        case "ema5": return .ema5
        case "ema10": return .ema10
        case "ema20": return .ema20
        case "ema50": return .ema50
        case "ema100": return .ema100
        case "ema200": return .ema200
        default: return nil
        }
    }
}

struct ChartData: Identifiable, Hashable {
    var id = UUID()
    var date: Date
    var value: Double
}

enum TimeDelta {
    case hour, day, week, month, year, allTime  // no week and allTime on backend
    
    var description: String {
        switch self {
        case .hour: return "H"
        case .day: return "D"
        case .week: return "W"
        case .month: return "M"
        case .year: return "Y"
        case .allTime: return "A"
        }
    }
    
    static func from(description: String) -> TimeDelta? {
        switch description {
        case "H": return .hour
        case "D": return .day
        case "W": return .week
        case "M": return .month
        case "Y": return .year
        case "A": return .allTime
        default: return nil
        }
    }
}
