//
//  ViewController.swift
//  AID
//
//  Created by Alexandr Sokolov on 19.03.2024.
//

import UIKit
import SnapKit
import SwiftUI

final class TabBarViewController: UITabBarController {

    // Создаем и конфигурируем кнопки для TabBar
    private func setupTabs() {
        let mainViewController = MainViewController()
        let mainViewPresenter = MainScreenPresenter(view: mainViewController)
        let profileView = UIHostingController(rootView: ProfileView())

        mainViewController.presenter = mainViewPresenter

        let favouritesViewController = FavouritesViewController()
        let favouritesViewPresenter = FavouritesScreenPresenter(view: favouritesViewController)

        favouritesViewController.presenter = favouritesViewPresenter

        let account = self.createNavigation(
            with: Texts.tabBarAccount,
            and: UIImage(systemName: "person.fill"),
            vc: profileView
        )
        let main = self.createNavigation(
            with: Texts.tabBarMain,
            and: UIImage(systemName: "wallet.pass.fill"),
            vc: mainViewController
        )
        let favourites = self.createNavigation(
            with: Texts.tabBarFavourite,
            and: UIImage(systemName: "star.fill"),
            vc: favouritesViewController
        )

        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = .background
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        UITabBar.appearance().standardAppearance = tabBarAppearance

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

private extension TabBarViewController {
    struct Texts {
        static let tabBarMain = String(localized: "Main")
        static let tabBarAccount = String(localized: "Profile")
        static let tabBarFavourite = String(localized: "Favorite")
    }
}
