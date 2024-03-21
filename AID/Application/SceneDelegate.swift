//
//  SceneDelegate.swift
//  AID
//
//  Created by Alexandr Sokolov on 19.03.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let sceneDelegate = (scene as? UIWindowScene) else {
            return
        }
        
        window = UIWindow(windowScene: sceneDelegate)
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
    }
}
