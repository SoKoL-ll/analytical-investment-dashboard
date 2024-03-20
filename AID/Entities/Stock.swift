//
//  Stock.swift
//  AID
//
//  Created by Alexander on 20.03.2024.
//

import Foundation

struct Stock {
    let name: String
    let ticker: String
    let price: Double
    let indicator: Indicator
}

struct Indicator {
    let type: IndicatorType
    let value: Double
}

enum IndicatorType {
    case first, second, third
}

struct ChartData: Identifiable, Hashable {
    var id = UUID()
    var date: Date
    var value: Double
}

enum TimeDelta {
    case hour, week, month, year, allTime
    
    var description: String {
        switch self {
            case .hour: return "H"
            case .week: return "W"
            case .month: return "M"
            case .year: return "Y"
            case .allTime: return "A"
        }
    }
    
    static func from(description: String) -> TimeDelta? {
        switch description {
            case "H": return .hour
            case "W": return .week
            case "M": return .month
            case "Y": return .year
            case "A": return .allTime
            default: return nil
        }
    }
}
