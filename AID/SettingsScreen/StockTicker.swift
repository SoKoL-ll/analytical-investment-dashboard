//
//  StockTicker.swift
//  SettingsScreenInSwiftUI
//
//  Created by Egor Anoshin on 25.03.2024.
//

import Foundation
import SwiftUI

struct StockTicker: Identifiable, Comparable {
    let id = UUID()
    var name: String
    var isFavorite: Bool

    static func < (lhs: StockTicker, rhs: StockTicker) -> Bool {
        lhs.name < rhs.name
    }
}

struct TickersView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var searchQuery = ""
    @State private var tickers = [
        StockTicker(name: "YNDX", isFavorite: false),
        StockTicker(name: "AAPL", isFavorite: true),
        StockTicker(name: "GOOGL", isFavorite: false),
    ]

    var filteredTickers: [StockTicker] {
        let sortedTickers = tickers.sorted {
            if $0.isFavorite != $1.isFavorite {
                return $0.isFavorite && !$1.isFavorite
            }
            return $0 < $1
        }

        if searchQuery.isEmpty {
            return sortedTickers
        } else {
            return sortedTickers.filter { $0.name.contains(searchQuery.uppercased()) }
        }
    }

    var body: some View {
        VStack {
            TextField("Search", text: $searchQuery)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            List {
                ForEach(filteredTickers) { ticker in
                    HStack {
                        Text(ticker.name).bold()
                        Spacer()
                        Image(systemName: ticker.isFavorite ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                            .onTapGesture {
                                if let index = self.tickers.firstIndex(where: { $0.id == ticker.id }) {
                                    self.tickers[index].isFavorite.toggle()
                                }
                            }
                    }
                }
            }

            Button("Back") {
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
        }
    }
}
