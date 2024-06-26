//
//  IndicatorDetailsView.swift
//  SwiftCharts
//
//  Created by Михаил Симаков on 25.03.2024.
//

import SwiftUI

struct IndicatorDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    
    let indicator: Indicator
    
    init(indicator: Indicator) {
        self.indicator = indicator
    }
    
    var verdictInformation: IndicatorVerdictInfo {
        DetailsController.getVerdictViewInformation(indicator.verdict)
    }
    
    var body: some View {
        ScrollView {
            Text(indicator.name ?? "")
                .multilineTextAlignment(.center)
                .font(.headline)
                .padding([.top, .horizontal])
            
            HStack {
                VStack {
                    Text("Value:")
                    
                    Text(indicator.formattedValue)
                        .fontWeight(.bold)
                        .font(.system(size: 30))
                        .frame(height: 50)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                
                if let systemName = verdictInformation.symbolSystemName {
                    Divider()
                    
                    VStack {
                        Text("Verdict:")
                        
                        VStack {
                            Image(systemName: systemName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                            Text(verdictInformation.description)
                        }
                        .foregroundStyle(verdictInformation.color)
                        .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.vertical, 20)
            
            Text("Description")
            Text(indicatorDescription ?? "")
                .padding(.horizontal)
            
            Spacer()
        }
        .background(Color(.background))
    }
    
    var indicatorDescription: AttributedString? {
        return try? AttributedString(
            markdown: indicator.description ?? "",
            options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)
        )
    }
}

#Preview {
    return IndicatorDetailsView(
        indicator: Indicator(
            type: "ma5",
            value: 123.123,
            postfix: "₽",
            name: "Скользящее среднее за 5 дней",
            description: "description",
            verdict: 1
        )
    )
}
