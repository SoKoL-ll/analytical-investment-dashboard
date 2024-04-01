//
//  DetailsView.swift
//  SwiftCharts
//
//  Created by Михаил Симаков on 22.03.2024.
//

import SwiftUI
import Charts

struct DetailsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var scheme
    @EnvironmentObject private var detailsController: DetailsController
    
    var navbarColor: Color {
        Color(
            UIColor(named: "Background")?
                .resolvedColor(with: .init(userInterfaceStyle: scheme == .dark ? .dark : .light)
                              ) ?? .white
        )
    }
    
    var body: some View {
        ScrollView {
            VStack {
                DetailsChartView()
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.backgroundPage))
                    )
                    .padding(.bottom)
                
                DetailsIndicatorsView()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.backgroundPage))
                    )
                
                Spacer()
            }
            .padding()
        }
        .refreshable {
            detailsController.reloadDetails()
            detailsController.reloadIndicators()
        }
        .background(Color(.background))
        .navigationTitle(detailsController.ticker)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(String(localized: "Add to favourites"), systemImage: detailsController.isFavourite ? "star.fill" : "star") {
                    detailsController.switchFavouriteState()
                }
            }
        }
        
        .toolbarBackground(navbarColor, for: .navigationBar)
        .onAppear {
            detailsController.loadFavouriteState()
        }
    }
}

#Preview {
    DetailsView()
        .environment(\.locale, .init(identifier: "ru"))
        .environmentObject(DetailsController(ticker: "GAZP"))
}
