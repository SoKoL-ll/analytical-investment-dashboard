//
//  BubbleViewFactory.swift
//  AID
//
//  Created by Alexandr Sokolov on 23.03.2024.
//

import Foundation
import UIKit

class BubbleViewFactory {

    // Создание кругов для каждой компании
    static func make(
        companies: [String],
        sizeOfView: CGRect,
        bubbleDidTap: @escaping (String) -> Void,
        completion: ([BubbleView]) -> Void
    ) {
        var bubbleViews = [BubbleView]()

        for company in companies {
            let bubbleView = BubbleView(companyName: company, bubbleDidTap: bubbleDidTap)
            let maxSize: CGFloat = Constants.defaultBubbleSize + CGFloat.random(in: (0 ... 50))
            let x = CGFloat.random(in: (sizeOfView.origin.x ... (sizeOfView.origin.x + sizeOfView.width - maxSize - Constants.largeMargin)))
            let y: CGFloat = CGFloat.random(
                in: (sizeOfView.origin.y ... (sizeOfView.origin.y + sizeOfView.height - maxSize - Constants.largeMargin))
            )
            let origin: CGPoint = CGPoint(x: x, y: y)
            
            bubbleView.backgroundColor = maxSize > 95 ? .positive : .negative
            bubbleView.frame = CGRect(origin: origin, size: CGSize(width: maxSize, height: maxSize))
            bubbleView.layer.cornerRadius = bubbleView.frame.width / 2
            bubbleViews.append(bubbleView)
        }

        completion(bubbleViews)
    }
}
