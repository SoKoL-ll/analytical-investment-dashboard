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
            HStack(spacing: 0) {
                Rectangle()
                    .fill(.red)
                    .frame(height: 10)
                    .containerRelativeFrame(
                        .horizontal,
                        count: detailsController.tickerProsConsData.sum,
                        span: detailsController.tickerProsConsData.cons,
                        spacing: 0
                    )
                
                Rectangle()
                    .fill(.green)
                    .frame(height: 10)
                    .containerRelativeFrame(
                        .horizontal,
                        count: detailsController.tickerProsConsData.sum,
                        span: detailsController.tickerProsConsData.pros,
                        spacing: 0
                    )
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            HStack {
                Text("- \(detailsController.tickerProsConsData.cons)")
                    .bold()
                    .foregroundStyle(Color(.red))
                
                Spacer()
                
                Text("+ \(detailsController.tickerProsConsData.pros)")
                    .bold()
                    .foregroundStyle(Color(.green))
            }
        }
    }
}

#Preview {
    DetailsIndicatorsBarView()
        .environmentObject(DetailsController(ticker: "SBER"))
}
