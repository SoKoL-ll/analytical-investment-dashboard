//
//  ViewController.swift
//  AID
//
//  Created by Alexandr Sokolov on 19.03.2024.
//

import UIKit
import SnapKit

class ViewController: UITabBarController {

    // Создаем и конфигурируем кнопки для TabBar
    private func setupTabs() {
        let mainViewController = MainViewController()
        let mainViewPresenter = MainScreenPresenter(view: mainViewController)

        mainViewController.delegate = mainViewPresenter

        let account = self.createNavigation(
            with: "Общее",
            and: UIImage(systemName: "wallet.pass.fill"),
            vc: AccountViewController()
        )
        let main = self.createNavigation(
            with: "Главная",
            and: UIImage(systemName: "person.fill"),
            vc: mainViewController
        )
        let favourites = self.createNavigation(
            with: "Избранное",
            and: UIImage(systemName: "star.fill"),
            vc: FavouritesViewController()
        )

        tabBar.backgroundColor = .black
        
        self.setViewControllers([account, main, favourites], animated: true)
        self.selectedViewController = self.viewControllers?[1]
    }

    private func createNavigation(with title: String?, and image: UIImage?, vc: UIViewController) -> UINavigationController {
        let navigation = UINavigationController(rootViewController: vc)

        navigation.tabBarItem.title = title
        navigation.tabBarItem.image = image
        navigation.isNavigationBarHidden = true
        return navigation
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
}