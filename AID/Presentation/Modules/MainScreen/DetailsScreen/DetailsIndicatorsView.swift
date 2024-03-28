//
//  DetailsIndicatorsView.swift
//  SwiftCharts
//
//  Created by Михаил Симаков on 24.03.2024.
//

import SwiftUI

struct DetailsIndicatorsView: View {
    @EnvironmentObject private var detailsController: DetailsController
    @State private var selectedIndicator: Indicator?
    
    var body: some View {
        VStack {
            Text("Результаты аналитики")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            
            switch detailsController.indicatorsLoadingState {
            case .fetching:
                ProgressView()
            case .loaded:
                loadedState()
            case .error:
                Text("ошибка")
            }
        }
        .frame(maxWidth: .infinity)
        .onAppear {
            detailsController.loadIndicators()
        }
    }
    
    func loadedState() -> some View {
        VStack(alignment: .leading) {
//            DetailsIndicatorsBarView()
//                .padding()
            
            Divider()
            
            ForEach(detailsController.indicatorsForView) { indicator in
                HStack {
                    HStack {
                        getIndicatorVerdictView(indicator)
                            .frame(width: 32)
                        
                        Text(indicator.type)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(indicator.formattedValue)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    Image(systemName: "questionmark.circle")
                        .foregroundStyle(.link)
                }
                .padding(.horizontal)
                .contentShape(Rectangle())
                .onTapGesture {
                    self.selectedIndicator = indicator
                }
                
                Divider()
            }
        }
        .sheet(item: $selectedIndicator, content: { indicator in
            IndicatorDetailsView(indicator: indicator)
        })
    }
    
    @ViewBuilder
    func getIndicatorVerdictView(_ indicator: Indicator) -> some View {
        let info = indicator.getVerdictViewInformation()
        
        if let info {
            Image(systemName: info.symbolSystemName)
                .foregroundStyle(info.color)
                .fontWeight(.bold)
        } else {
            Spacer()
                .padding(0)
        }
    }
}

#Preview {
    DetailsIndicatorsView()
}
