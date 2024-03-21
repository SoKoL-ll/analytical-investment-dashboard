//
//  CoordinatorImpl.swift
//  AID
//
//  Created by Alexandr Sokolov on 20.03.2024.
//

import Foundation
import UIKit

class CoordinatorImpl: Coordinator {
    private weak var window: UIWindow?
    func start(in window: UIWindow) {
        self.window = window
//        setupWindow()
        openMain()
    }

//    private func setupWindow() {
//
//    }

    private func openMain() {
        let mainViewController = ViewController()
        window?.rootViewController = mainViewController
        self.window?.makeKeyAndVisible()
//        window?.rootViewController?.show(mainViewController, sender: true)
//        window?.rootViewController?.present(mainViewController, animated: true)
    }
}
