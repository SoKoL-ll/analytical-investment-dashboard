//
//  ThemeManager.swift
//  AID
//
//  Created by Egor Anoshin on 28.03.2024.
//

import Foundation
import SwiftUI

class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    
    @Published var selectedThemeIndex: Int = UserDefaults.standard.integer(forKey: "selectedThemeIndex") {
        didSet {
            UserDefaults.standard.set(selectedThemeIndex, forKey: "selectedThemeIndex")
            applyTheme()
        }
    }
    
    private init() {
        applyTheme()
    }
    
    func applyTheme() {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                return
            }
            guard let window = windowScene.windows.first else {
                return
            }
            
            switch self.selectedThemeIndex {
            case 1:
                window.overrideUserInterfaceStyle = .light
            case 2:
                window.overrideUserInterfaceStyle = .dark
            default:
                window.overrideUserInterfaceStyle = .unspecified
            }
        }
    }
}
