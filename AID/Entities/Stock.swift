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

struct TickerInfo {
    let shortName: String
    let fullName: String
}

struct Indicator: Identifiable {
    var id: String { type }
    
    let type: String
    let value: Double?
    let postfix: String
    let name: String?
    let description: String?
    let verdict: Double?
    
    init(type: String, value: Double? = nil, postfix: String, name: String? = nil, description: String? = nil, verdict: Double? = nil) {
        self.type = type
        self.value = value
        self.postfix = postfix
        self.name = name
        self.description = description
        self.verdict = verdict
    }
}

struct StockInfo {
    let shortName: String
    let fullName: String
    let price: Double
    let indicators: [Indicator]
}

struct ChartData: Identifiable, Hashable {
    var id = UUID()
    let open: Double
    let close: Double
    let high: Double
    let low: Double
    let begin: Date
    let end: Date
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
