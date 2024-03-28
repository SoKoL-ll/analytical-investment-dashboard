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
    @EnvironmentObject private var detailsController: DetailsController
    
    var body: some View {
        ScrollView {
            VStack {
                DetailsChartView()
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(UIColor.systemBackground))
                            .shadow(radius: 2)
                    )
                    .padding(.bottom)
                
                DetailsIndicatorsView()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(UIColor.systemBackground))
                            .shadow(radius: 2)
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
                Button("Add to favourites", systemImage: "star") {
                    print("Super star!")
                }
            }
        }
    }
}

#Preview {
    DetailsView()
        .environment(\.locale, .init(identifier: "ru"))
        .environmentObject(DetailsController(ticker: "GAZP"))
}
