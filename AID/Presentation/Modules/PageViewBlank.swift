//
//  PageViewBlank.swift
//  AID
//
//  Created by Alexandr Sokolov on 22.03.2024.
//

import Foundation
import UIKit

class PageViewBlank: UIScrollView {

    private var pageInfo: PageInfo
    private let bubbleDidTap: (String) -> Void
    private var isScrollViewEnable: Bool
    weak var viewDelegate: ViewControllerDelegateFavourites?
    private var bubbles: [BubbleView] {
        didSet {
            self.bubbles.forEach {
                $0.removeFromSuperview()
            }

            bubbles.forEach { bubbleView in
                self.addSubview(bubbleView)

                self.collision.addItem(bubbleView)
                self.behavior.addItem(bubbleView)
                self.gravity.addItem(bubbleView)
            }
        }
    }

    private lazy var companiesTypeLabel: UILabel = {
        let label = UILabel()

        label.text = self.pageInfo.shortName
        label.numberOfLines = 2
        label.font = .boldSystemFont(ofSize: Constants.fontSizeLabelCompanyType)

        return label
    }()

    private lazy var fullDescriptionCompanyType: UILabel = {
        let label = UILabel()

        label.text = self.pageInfo.fullName
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        label.alpha = 0.5
        label.font = .boldSystemFont(ofSize: Constants.fontSizeLabelCompanyTypeFullDescription)

        return label
    }()

    init(pageInfo: PageInfo, isScrollViewEnable: Bool, delegate: ViewControllerDelegateFavourites, bubbleDidTap: @escaping (String) -> Void) {
        self.viewDelegate = delegate
        self.pageInfo = pageInfo
        self.bubbleDidTap = bubbleDidTap
        self.bubbles = []
        self.isScrollViewEnable = isScrollViewEnable

        super.init(frame: .zero)

        self.backgroundColor = .backGroundPage

        if isScrollViewEnable {
            setupScrollView()
        } else {
            self.layer.cornerRadius = Constants.cornerRadius
            setupLabel()
            self.isHidden = true
        }

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

        collision.collisionMode = isScrollViewEnable ? .items : .everything
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
        gravity.strength = 10

        return gravity
    }()

    private func setupAnimation() {
        self.setupBubbles()
        self.setupCenter()
    }

    // Создаем и конфигурируем наши круги
    func setupBubbles() {
        self.bubbles = BubbleViewFactory.make(
            tickers: pageInfo.tickers,
            metricType: pageInfo.metricType,
            delegate: viewDelegate,
            isScrollEnabled: self.isScrollViewEnable,
            bubbleDidTap: bubbleDidTap
        )
    }

    func setupLabel() {
        self.addSubview(companiesTypeLabel)

        companiesTypeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(Constants.mediumMargin)
        }

        self.addSubview(fullDescriptionCompanyType)

        fullDescriptionCompanyType.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(companiesTypeLabel.snp.bottom).inset(-Constants.smallMargin)
            make.leading.trailing.equalToSuperview().inset(Constants.bigMargin)
        }
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
        gravity.position = isScrollViewEnable ?
        CGPoint(x: contentSize.width / 2, y: contentSize.height / 2) :
        CGPoint(x: (self.frame.width) / 2, y: (self.frame.height) / 1.5)
    }

    private func setupScrollView() {
        self.backgroundColor = .clear
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.contentSize = CGSize(
            width: UIScreen.main.bounds.width * 2,
            height: UIScreen.main.bounds.height * 2
        )

        let offset = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)

        self.setContentOffset(offset, animated: true)
    }
}
