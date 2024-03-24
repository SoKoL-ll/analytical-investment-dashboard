//
//  ViewController.swift
//  AID
//
//  Created by Alexandr Sokolov on 19.03.2024.
//

import UIKit
import SnapKit

class TabBarViewController: UITabBarController {

    // Создаем и конфигурируем кнопки для TabBar
    private func setupTabs() {
        let mainViewController = MainViewController()
        let mainViewPresenter = MainScreenPresenter(view: mainViewController)

        mainViewController.delegate = mainViewPresenter

        let account = self.createNavigation(
            with: Texts.tabBarAccount,
            and: UIImage(systemName: "person.fill"),
            vc: AccountViewController()
        )
        let main = self.createNavigation(
            with: Texts.tabBarMain,
            and: UIImage(systemName: "wallet.pass.fill"),
            vc: mainViewController
        )
        let favourites = self.createNavigation(
            with: Texts.tabBarFavourite,
            and: UIImage(systemName: "star.fill"),
            vc: FavouritesViewController()
        )

        tabBar.backgroundColor = .background
        
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
