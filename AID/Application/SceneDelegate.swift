//
//  SceneDelegate.swift
//  AID
//
//  Created by Alexandr Sokolov on 19.03.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: Coordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let sceneDelegate = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: sceneDelegate)
        self.window = window
//        self.window?.rootViewController = ViewController()
//        self.window?.makeKeyAndVisible()
        self.coordinator = CoordinatorImpl()
        self.coordinator?.start(in: window)
    }
}
