//
//  PageViewFactory.swift
//  AID
//
//  Created by Alexandr Sokolov on 23.03.2024.
//

import Foundation

class PageViewFactory {
    // Создаем наши pageViews
    func make(
        sizeOfView: CGRect,
        companies: [String],
        countOfViews: Int,
        completion: @escaping (String) -> Void
    ) -> [PageViewBlank] {
        var views = [PageViewBlank]()

        for _ in 0..<countOfViews {
            views.append(PageViewBlank(companies: companies, sizeOfView: sizeOfView, completion: completion))
        }

        return views
    }
}
