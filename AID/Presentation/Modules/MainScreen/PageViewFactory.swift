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
        pagesInfo: [PageInfo],
        countOfViews: Int,
        delegate: ViewControllerDelegateFavourites,
        bubbleDidTap: @escaping (String) -> Void
    ) -> [PageViewBlank] {
        var views = [PageViewBlank]()

        for pageInfo in pagesInfo {
            views.append(PageViewBlank(
                pageInfo: pageInfo,
                isScrollViewEnable: false,
                delegate: delegate,
                bubbleDidTap: bubbleDidTap
            ))
        }

        return views
    }
}
