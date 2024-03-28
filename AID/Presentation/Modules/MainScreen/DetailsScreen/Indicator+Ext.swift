//
//  Indicator+Ext.swift
//  SwiftCharts
//
//  Created by Михаил Симаков on 26.03.2024.
//

import Foundation
import SwiftUI

struct IndicatorVertictInfo {
    let color: Color
    let symbolSystemName: String
    let description: String
}

extension Indicator {
    // returns system name of verdict image and color for that image
    func getVerdictViewInformation() -> IndicatorVertictInfo? {
        guard let verdict else {
            return nil
        }
        
        if verdict < 0 {
            return .init(color: Color(.red), symbolSystemName: "minus", description: "Стоит продавать")
        } else if verdict > 0 {
            return .init(color: Color(.green), symbolSystemName: "plus", description: "Стоит покупать")
        }
        
        return .init(color: .secondary, symbolSystemName: "equal", description: "Нейтрально")
    }
    
    var formattedValue: String {
        String(format: "%.2f", self.value ?? 0) + self.postfix
    }
}
