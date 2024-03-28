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
        StockTicker(name: "AAPL", isFavorite: false),
        StockTicker(name: "GOOGL", isFavorite: false),
        StockTicker(name: "SBER", isFavorite: false),
        StockTicker(name: "GAZPROM", isFavorite: false),
        StockTicker(name: "ALFA", isFavorite: false),
        StockTicker(name: "SP500", isFavorite: false)
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
            NavigationView {
                VStack {
                    TextField("Search", text: $searchQuery)
                        .padding(10)
                        .padding(.horizontal, 25)
                        .background(Color(UIColor.systemBackground))
                        .cornerRadius(15)
                        .foregroundColor(Color.primary)
                        .overlay(
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(Color(UIColor.secondaryLabel))
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 8)
                            }
                        )
                        .padding(.horizontal, 20)
                        .padding(.top, 10)

                    List {
                        ForEach(filteredTickers) { ticker in
                            HStack {
                                Text(ticker.name).bold()
                                Spacer()
                                Image(systemName: ticker.isFavorite ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                                    .onTapGesture {
                                        if let index = self.tickers.firstIndex(where: { $0.id == ticker.id }) {
                                            withAnimation {
                                                self.tickers[index].isFavorite.toggle()
                                            }
                                        }
                                    }
                            }
                        }
                    }
                    .navigationBarItems(leading: Button("Back") {
                        presentationMode.wrappedValue.dismiss()
                    })
                    .navigationBarTitle("", displayMode: .inline)
                }
            }
        }
}
