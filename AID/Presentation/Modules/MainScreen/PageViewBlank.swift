//
//  PageViewBlank.swift
//  AID
//
//  Created by Alexandr Sokolov on 22.03.2024.
//

import Foundation
import UIKit

class PageViewBlank: UIView {

    private var companies: [String]
    private let sizeOfVIew: CGRect
    private let bubbleDidTap: (String) -> Void

    init(companies: [String], sizeOfView: CGRect, bubbleDidTap: @escaping (String) -> Void) {
        self.companies = companies
        self.sizeOfVIew = sizeOfView
        self.bubbleDidTap = bubbleDidTap

        super.init(frame: .zero)

        self.backgroundColor = .black
        self.layer.cornerRadius = Constants.cornerRadius
        self.isHidden = true

        setupAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Объект, который управляет всей анимацией
    private lazy var animator: UIDynamicAnimator = {
        let animator = UIDynamicAnimator(referenceView: self)

        return animator
    }()

    // Объект, который позволяет обрабатывать столкновения между представлениями
    private lazy var collision: UICollisionBehavior = {
        let collision = UICollisionBehavior()

        collision.collisionMode = .everything
        collision.translatesReferenceBoundsIntoBoundary = true

        return collision
    }()

    // Объект, который представляет собой поведение анимации
    private lazy var behavior: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()

        behavior.allowsRotation = true
        behavior.elasticity = 0
        behavior.density = 0
        behavior.friction = 0
        behavior.resistance = 2

        return behavior
    }()

    // Объект, который оказывает воздействие на объекты с помощью гравитации
    private lazy var gravity: UIFieldBehavior = {
        let gravity = UIFieldBehavior.springField()

        gravity.animationSpeed = 0
        gravity.smoothness = 1
        gravity.strength = 3

        return gravity
    }()

    private func setupAnimation() {
        self.setupBubbles()
        self.setupBehaviors()
        self.setupCenter()
    }

    // Создаем и конфигурируем наши круги
    func setupBubbles() {
        BubbleViewFactory.make(
            companies: companies,
            sizeOfView: self.sizeOfVIew,
            bubbleDidTap: bubbleDidTap
        ) { [weak self] bubbleViews in
            guard let self = self else {
                return
            }

            bubbleViews.forEach { bubbleView in

                self.collision.addItem(bubbleView)
                self.behavior.addItem(bubbleView)
                self.gravity.addItem(bubbleView)

                self.addSubview(bubbleView)
            }
        }
    }

    // Добавляем все объекты, связанные с анимацией в основной класс
    private func setupBehaviors() {
        animator.addBehavior(collision)
        animator.addBehavior(behavior)
        animator.addBehavior(gravity)
    }

    // Задаем центр гравитации
    private func setupCenter() {
        gravity.position = CGPoint(x: self.sizeOfVIew.width / 2, y: self.sizeOfVIew.height / 2)
    }
}
