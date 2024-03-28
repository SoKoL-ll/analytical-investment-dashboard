//
//  ClosedRange+Ext.swift
//  SwiftCharts
//
//  Created by Михаил Симаков on 25.03.2024.
//

import Foundation

extension ClosedRange {
    func clamp(_ value: Bound) -> Bound {
        return self.lowerBound > value ? self.lowerBound
        : self.upperBound < value ? self.upperBound
        : value
    }
}
