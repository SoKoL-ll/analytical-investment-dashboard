//
//  TickersViewModel.swift
//  AID
//
//  Created by Egor Anoshin on 28.03.2024.
//

import Foundation
import Alamofire

class TickersViewModel: ObservableObject {
    @Published var tickers: [StockTicker] = []
    @Published var isLoading = true

    init() {
        loadTickers()
    }

    func loadTickers() {
        NetworkManager.shared.getStocks(with: "rsi") { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let (stockArray, _)):
                    self?.isLoading = false
                    let loadedTickers = stockArray.map { StockTicker(name: $0.ticker, isFavorite: false) }
                    self?.tickers = self?.loadFavorites(tickers: loadedTickers) ?? []
                case .failure:
                    self?.isLoading = false
                }
            }
        }
    }

    private func loadFavorites(tickers: [StockTicker]) -> [StockTicker] {
        guard let savedFavorites = UserDefaults.standard.stringArray(forKey: "favourites") else {
            return tickers
        }
        return tickers.map { ticker in
            var updatedTicker = ticker
            updatedTicker.isFavorite = savedFavorites.contains(ticker.name)
            return updatedTicker
        }
    }

    func toggleFavorite(tickerName: String) {
        guard let index = tickers.firstIndex(where: { $0.name == tickerName }) else {
            return
        }
        tickers[index].isFavorite.toggle()

        let favorites = tickers.filter { $0.isFavorite }.map { $0.name }
        UserDefaults.standard.set(favorites, forKey: "favourites")
    }
}
