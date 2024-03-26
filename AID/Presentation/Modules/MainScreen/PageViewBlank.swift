//
//  PageViewBlank.swift
//  AID
//
//  Created by Alexandr Sokolov on 22.03.2024.
//

import Foundation
import UIKit

final class PageViewBlank: UIView {

    private var companies: [String]
    private let bubbleDidTap: (String) -> Void
    private var isBubblesConfigurated = false

    private var bubbles: [BubbleView] {
        didSet {
            bubbles.forEach { bubbleView in
                self.addSubview(bubbleView)

                self.collision.addItem(bubbleView)
                self.behavior.addItem(bubbleView)
                self.gravity.addItem(bubbleView)
            }
        }
    }

    init(companies: [String], bubbleDidTap: @escaping (String) -> Void) {
        self.companies = companies
        self.bubbleDidTap = bubbleDidTap
        self.bubbles = []

        super.init(frame: .zero)

        self.backgroundColor = .black
        self.layer.cornerRadius = Constants.cornerRadius
        self.isHidden = true

        setupBehaviors()
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
        self.setupCenter()
    }

    // Создаем и конфигурируем наши круги
    func setupBubbles() {
        self.bubbles = BubbleViewFactory.make(
            companies: companies,
            bubbleDidTap: bubbleDidTap
        )
    }

    // Добавляем все объекты, связанные с анимацией в основной класс
    private func setupBehaviors() {
        animator.addBehavior(collision)
        animator.addBehavior(behavior)
        animator.addBehavior(gravity)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if self.bubbles.isEmpty {
            setupAnimation()
        }
    }
    // Задаем центр гравитации
    private func setupCenter() {
        gravity.position = CGPoint(x: (self.frame.width) / 2, y: (self.frame.height) / 2)
    }
}
