//
//  StockSettingsViewModel.swift
//  AID
//
//  Created by Egor Anoshin on 28.03.2024.
//

import Foundation
import Alamofire

class StockSettingsViewModel: ObservableObject {
    @Published var categories: [String] = []

    func loadCategories() {
        NetworkManager.shared.getCategories { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let categories):
                    self?.categories = categories
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
