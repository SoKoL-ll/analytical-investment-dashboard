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
    @ObservedObject var viewModel: TickersViewModel
    @State private var searchQuery = ""

    var filteredTickers: [StockTicker] {
        viewModel.tickers.filter { ticker in
            searchQuery.isEmpty || ticker.name.contains(searchQuery.uppercased())
        }.sorted {
            if $0.isFavorite == $1.isFavorite {
                return $0.name < $1.name
            }
            return $0.isFavorite && !$1.isFavorite
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                TextField("Search", text: $searchQuery)
                    .padding()
                    .padding(.leading, 35)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(15)
                    .overlay(
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .padding(.leading, 10)
                            Spacer()
                        }
                    )
                    .padding()
                List {
                    ForEach(filteredTickers) { ticker in
                        HStack {
                            Text(ticker.name).bold()
                            Spacer()
                            Image(systemName: ticker.isFavorite ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                                .onTapGesture {
                                    withAnimation {
                                        viewModel.toggleFavorite(tickerName: ticker.name)
                                    }
                                }
                        }
                    }
                }
                .animation(.default, value: filteredTickers)
                .navigationBarItems(leading: Button("Back") {
                    presentationMode.wrappedValue.dismiss()
                })
            }
        }
    }
}

extension TextField {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        overlay(
            ZStack(alignment: alignment) {
                if shouldShow {
                    placeholder()
                }
            }
        )
    }
}
