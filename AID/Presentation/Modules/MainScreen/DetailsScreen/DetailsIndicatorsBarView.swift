//
//  DetailsIndicatorsBarView.swift
//  SwiftCharts
//
//  Created by Михаил Симаков on 27.03.2024.
//

import SwiftUI

struct DetailsIndicatorsBarView: View {
    @EnvironmentObject private var detailsController: DetailsController
    
    var body: some View {
        VStack {
            Text("Стоит покупать").textCase(.uppercase).fontWeight(.black).foregroundStyle(Color(.green))
                .frame(maxWidth: .infinity, alignment: .center)
            
            GeometryReader { metrics in
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(Color(.red))
                        .frame(width: metrics.size.width * detailsController.tickerProsConsData.consPercentage, height: 10)
                    
                    Rectangle()
                        .fill(Color(.green))
                        .frame(width: metrics.size.width * detailsController.tickerProsConsData.prosPercentage, height: 10)
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            HStack {
                if detailsController.tickerProsConsData.cons != 0 {
                    Text("- \(detailsController.tickerProsConsData.cons)")
                        .bold()
                        .foregroundStyle(Color(.red))
                }
                
                Spacer()
                
                if detailsController.tickerProsConsData.pros != 0 {
                    Text("+ \(detailsController.tickerProsConsData.pros)")
                        .bold()
                        .foregroundStyle(Color(.green))
                }
            }
        }
    }
}

#Preview {
    DetailsIndicatorsBarView()
        .environmentObject(DetailsController(ticker: "SBER"))
}
