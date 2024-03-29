//
//  BubbleViewFactory.swift
//  AID
//
//  Created by Alexandr Sokolov on 23.03.2024.
//

import Foundation
import UIKit

final class BubbleViewFactory {
    // Создание кругов для каждой компании
    static func make(
        tickers: [String: (Double, Double)],
        metricType: String,
        delegate: ViewControllerDelegateFavourites?,
        isScrollEnabled: Bool,
        bubbleDidTap: @escaping (String) -> Void
    ) -> [BubbleView] {
        tickers.map {
            BubbleView(companyName: $0.key,
                       companySize: $0.value.0,
                       value: $0.value.1,
                       metricType: metricType,
                       isScrollEnabled: isScrollEnabled,
                       delegate: delegate,
                       bubbleDidTap: bubbleDidTap
            )
        }
    }
}
