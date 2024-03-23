//
//  ViewController.swift
//  AID
//
//  Created by Alexandr Sokolov on 19.03.2024.
//

import UIKit
import SnapKit

protocol MainViewControllerDelegate: AnyObject {
    func setContent()
}

class MainViewController: UIViewController {

    private let pageViewFactory = PageViewFactory()
    private var currentViewIndex: Int = 0
    private var initialPosition: CGPoint = .zero
    private var swipeableViews: [PageViewBlank] = []

    var delegate: MainScreenPresenter!

    // Заглушка для PageView, пока у нас нет данных
    private lazy var plugPageView: UIView = {
        let view = UIView()

        view.backgroundColor = .systemGray.withAlphaComponent(0.5)
        view.layer.cornerRadius = 20

        return view
    }()

    // Навигация под PageView, нажатия на нее еще не реализованы
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()

        pageControl.currentPage = 0

        return pageControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupPageControl()
        setupPlugPageView()

        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))

        view.addGestureRecognizer(panGestureRecognizer)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.delegate.launchData()
    }

    private func setupPlugPageView() {
        let parentController = self.parent as? UITabBarController

        view.addSubview(plugPageView)

        plugPageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(60)
            make.bottom.equalTo(parentController?.tabBar.snp_firstBaseline ?? 0).inset(120)
        }
    }

    private func setupPageControl() {
        view.addSubview(pageControl)

        let parentController = self.parent as? UITabBarController

        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(parentController?.tabBar.snp_firstBaseline ?? 0).inset(90)
        }
    }

    private func setupView() {
        view.isOpaque = true
        view.backgroundColor = .systemGray3
    }

    // Обработка свайпов pageViews
    @objc private func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: view)
        var index = (currentViewIndex + (Int(translation.x) < 0 ? 1 : -1)) % swipeableViews.count

        index = index == -1 ? swipeableViews.count - 1 : index

        switch gestureRecognizer.state {
        case .began:
            initialPosition = swipeableViews[currentViewIndex].center
        case .changed:
            swipeableViews[currentViewIndex].center = CGPoint(x: initialPosition.x + translation.x, y: initialPosition.y)
            if abs(translation.x) > 10 {
                swipeableViews[index].isHidden = false
                swipeableViews[index].center = CGPoint(
                    x: swipeableViews[currentViewIndex].center.x
                    + (translation.x < 0 ? 1 : -1) * (swipeableViews[currentViewIndex].frame.width + 30),
                    y: initialPosition.y
                )
            } else {
                swipeableViews[index].isHidden = true
            }
        case .ended, .cancelled:
            if abs(translation.x) > swipeableViews[currentViewIndex].frame.width / 2 {
                UIView.animate(withDuration: 0.3, animations: { [self] in
                    swipeableViews[index].center = self.initialPosition
                    swipeableViews[currentViewIndex].center.x = self.initialPosition.x
                    + (translation.x > 0 ? 1 : -1) * (swipeableViews[currentViewIndex].frame.width + 30)
                }, completion: { _ in
                    self.swipeableViews[self.currentViewIndex].isHidden = true
                    self.currentViewIndex = index
                    self.pageControl.currentPage = index
                })
            } else {
                UIView.animate(withDuration: 0.3, animations: { [self] in
                    swipeableViews[currentViewIndex].center = self.initialPosition
                    if translation.x > 0 {
                        swipeableViews[index].center.x = self.initialPosition.x - swipeableViews[index].frame.width - 30
                    } else {
                        swipeableViews[index].center.x = self.initialPosition.x + swipeableViews[index].frame.width + 30
                    }
                }, completion: { _ in
                    self.swipeableViews[index].isHidden = true
                })
            }
        default:
            break
        }
    }
}

extension MainViewController: MainViewControllerDelegate {
    
    // Конфигурирует наши pageViews и все, что в них находится
    func setContent() {
        let views = pageViewFactory.make(
            sizeOfView: plugPageView.frame,
            companies: ["YNDX", "VKCOM", "META", "TLGRM", "SBR", "RSNT", "TT", "TNKF", "GZPRM"],
            countOfViews: 5
        ) { [weak self] companyName in

            guard let self = self else {
                return
            }

            self.delegate.openInfoAboutCompany(companyName: companyName)
        }

        views.forEach { pageView in
            self.view.addSubview(pageView)

            let parentController = self.parent as? UITabBarController

            pageView.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(20)
                make.top.equalToSuperview().inset(60)
                make.bottom.equalTo(parentController?.tabBar.snp_firstBaseline ?? 0).inset(120)
            }

            self.swipeableViews.append(pageView)
            self.swipeableViews.first?.isHidden = false
        }

        self.pageControl.numberOfPages = swipeableViews.count

        if !(self.swipeableViews.isEmpty) {
            self.plugPageView.isHidden = true
        }
    }
}
