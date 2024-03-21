//
//  ViewController.swift
//  AID
//
//  Created by Alexandr Sokolov on 19.03.2024.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: view.bounds)

        scrollView.backgroundColor = .clear
        scrollView.contentSize = CGSize(width: view.bounds.width * 2, height: view.bounds.height * 2)

        return scrollView
    }()

    private lazy var animator: UIDynamicAnimator = {
        let animator = UIDynamicAnimator(referenceView: scrollView)

        return animator
    }()

    private lazy var collision: UICollisionBehavior = {
        let collision = UICollisionBehavior()

        collision.collisionMode = .items

        return collision
    }()

    private lazy var behavior: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()

        behavior.allowsRotation = false
        behavior.elasticity = 0
        behavior.density = 0
        behavior.friction = 0
        behavior.resistance = 2

        return behavior
    }()

    private lazy var gravity: UIFieldBehavior = {
        let gravity = UIFieldBehavior.springField()

        gravity.animationSpeed = 0
        gravity.smoothness = 1
        gravity.strength = 3

        return gravity
    }()

    private func createNavigation(with title: String?, and image: UIImage?, vc: UIViewController) -> UINavigationController {
        let navigation = UINavigationController(rootViewController: vc)

        navigation.tabBarItem.title = title
        navigation.tabBarItem.image = image

        return navigation
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupScrollView()
        setupAnimation()
    }

    private func setupScrollView() {
        view.addSubview(scrollView)

        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false

        let parentController = self.parent as? UITabBarController
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(parentController?.tabBar.snp_firstBaseline ?? 0)
        }
    }

    private func setupView() {
        view.isOpaque = true
        view.backgroundColor = .systemGray3
    }

    private func setupAnimation() {
        self.setupBubbles()
        self.setupBehaviors()
        self.setupCenter()
    }

    private func setupBubbles() {
        for index in 0...20 {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap(_:)))
            let x: CGFloat = (index % 2) == 0 ?
            CGFloat.random(in: (-2000.0 ... -200)) :
            CGFloat.random(in: (600 ... 2000))

            let y: CGFloat = CGFloat.random(in: (-2000.0 ... 3000))
            let origin: CGPoint = CGPoint(x: x, y: y)
            let maxSize: CGFloat = 50 + CGFloat.random(in: (0 ... 70))

            let bubbleView = BubbleView(companyName: "YNDX")

            bubbleView.addGestureRecognizer(tapGesture)
            bubbleView.addGestureRecognizer(longTapGesture)
            bubbleView.backgroundColor = maxSize > 85 ? UIColor(named: "newGreen") : UIColor(named: "newRed")
            bubbleView.frame = CGRect(origin: origin, size: CGSize(width: maxSize, height: maxSize))
            bubbleView.layer.cornerRadius = bubbleView.frame.width / 2

            gravity.addItem(bubbleView)
            collision.addItem(bubbleView)
            behavior.addItem(bubbleView)

            scrollView.addSubview(bubbleView)
        }
    }

    private func setupBehaviors() {
        animator.addBehavior(collision)
        animator.addBehavior(behavior)
        animator.addBehavior(gravity)
    }

    private func setupCenter() {
        gravity.position = CGPoint(x: scrollView.contentSize.width * 0.3, y: scrollView.contentSize.height * 0.3)
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view as? BubbleView else {
            return
        }

        print("Do something")
    }

    @objc func longTap(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view as? BubbleView else {
            return
        }

        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        generator.impactOccurred()
    }
}

extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        animator.updateItem(usingCurrentState: scrollView)
    }
}
