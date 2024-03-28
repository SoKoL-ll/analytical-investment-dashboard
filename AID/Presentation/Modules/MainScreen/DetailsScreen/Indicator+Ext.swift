//
//  Indicator+Ext.swift
//  SwiftCharts
//
//  Created by Михаил Симаков on 26.03.2024.
//

import Foundation

extension Indicator: Identifiable {
    var id: String { type }
}

extension Indicator {
    var formattedValue: String {
        String(format: "%.2f", self.value ?? 0) + self.postfix
    }
}
