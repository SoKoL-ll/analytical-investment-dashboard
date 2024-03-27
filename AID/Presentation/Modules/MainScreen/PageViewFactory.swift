//
//  PageViewFactory.swift
//  AID
//
//  Created by Alexandr Sokolov on 23.03.2024.
//

import Foundation

final class PageViewFactory {
    // Создаем наши pageViews
    func make(
        companies: [String],
        countOfViews: Int,
        bubbleDidTap: @escaping (String) -> Void
    ) -> [PageViewBlank] {
        var views = [PageViewBlank]()

        for _ in 0..<countOfViews {
            views.append(PageViewBlank(companies: companies, bubbleDidTap: bubbleDidTap))
        }

        return views
    }
}