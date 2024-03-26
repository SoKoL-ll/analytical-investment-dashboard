//
//  CoordinatorImpl.swift
//  AID
//
//  Created by Alexandr Sokolov on 20.03.2024.
//

import Foundation
import UIKit

protocol Coordinator {
    func start(in window: UIWindow?)
}

final class CoordinatorImpl: Coordinator {
    private weak var window: UIWindow?

    func start(in window: UIWindow?) {
        self.window = window
        openMain()
    }

    private func openMain() {
        let mainViewController = TabBarViewController()
        window?.rootViewController = mainViewController
        self.window?.makeKeyAndVisible()
    }
}
