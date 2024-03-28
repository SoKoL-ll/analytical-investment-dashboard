//
//  DetailsChartView.swift
//  SwiftCharts
//
//  Created by Михаил Симаков on 22.03.2024.
//

import SwiftUI
import Charts

struct DetailsChartView: View {
    @EnvironmentObject private var detailsController: DetailsController
    @State private var selectionPosition: Date?
    
    private var currentChartData: [ChartData] {
        detailsController.priceChartData[detailsController.priceChartTimeDelta] ?? []
    }

    private var yDomain: ClosedRange<Double> {
        let prices = currentChartData.map { $0.open }
        let dataMin = prices.min() ?? 0
        let dataMax = prices.max() ?? 0
        let offset = (dataMax - dataMin) * 0.1
        
        return (dataMin - offset)...(dataMax + offset)
    }
    
    private var xDomain: ClosedRange<Date> {
        let dates = currentChartData.map { $0.begin }
        let startDates = dates.min() ?? .now
        let endDates = dates.max() ?? .now
        return startDates...endDates
    }
    
    var body: some View {
        VStack {
            periodPicker
            
            stockPrice
        }
        .onAppear {
            detailsController.loadPriceChartData()
        }
        .onChange(of: detailsController.priceChartTimeDelta) {
            detailsController.loadPriceChartData()
        }
    }
    
    var periodPicker: some View {
        VStack(alignment: .leading) {
            Text("Цена акции")
            
            Picker("", selection: $detailsController.priceChartTimeDelta) {
                Text("Ч").tag(TimeDelta.hour)
                Text("Д").tag(TimeDelta.day)
                Text("Н").tag(TimeDelta.week)
                Text("М").tag(TimeDelta.month)
                Text("Г").tag(TimeDelta.year)
                Text("Всё").tag(TimeDelta.allTime)
            }
            .pickerStyle(.segmented)
        }
        .opacity(self.selectionPosition == nil ? 1 : 0)
    }
    
    func getClosestChartData(date: Date) -> ChartData? {
        guard var closestData = currentChartData.first else {
            return nil
        }
        
        var closestDataDistance = abs(closestData.begin.distance(to: date))
        
        for data in self.currentChartData {
            let distance = abs(data.begin.distance(to: date))
            if distance < closestDataDistance {
                closestData = data
                closestDataDistance = distance
            }
        }
        
        return closestData
    }
    
    @ViewBuilder
    var stockPrice: some View {
        switch detailsController.priceChartLoadingState {
        case .fetching:
            ProgressView()
                .frame(height: 250)
        case .loaded:
            if currentChartData.isEmpty {
                VStack {
                    Image(systemName: "eyes")
                    Text("Нет данных")
                }
                .fontWeight(.bold)
                .frame(height: 250)
            } else {
                stockPriceChart
            }
        case .error:
            VStack {
                Image(systemName: "exclamationmark.octagon")
                Text("Что-то пошло не так")
            }
            .frame(height: 250)
            .fontWeight(.bold)
        }
    }
    
    var stockPriceChart: some View {
        Chart {
            ForEach(currentChartData) { item in
                LineMark(
                    x: .value("Time", item.begin),
                    y: .value("Open", item.open)
                )
            }
            
            if let selectionPosition, let currentActiveItem = getClosestChartData(date: selectionPosition) {
                RuleMark(x: .value("Time", selectionPosition))
                    .lineStyle(.init(lineWidth: 2, miterLimit: 2, dash: [2], dashPhase: 5))
                    .annotation(position: .top, overflowResolution: .init(x: .fit)) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Цена акции")
                                .font(.caption)
                            
                            Text(getFormattedDate(currentActiveItem.begin))
                                .font(.caption)
                            
                            Text(String(currentActiveItem.open))
                                .font(.title3)
                                .bold()
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background {
                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .fill(Color(UIColor.secondarySystemBackground)).shadow(radius: 2)
                        }
                    }
            }
        }
        .chartYScale(domain: yDomain)
        .chartOverlay(content: { proxy in
            GeometryReader { _ in
                Rectangle()
                    .fill(.clear).contentShape(Rectangle())
                    .onTapGesture { }
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let location = value.location
                                if let date: Date = proxy.value(atX: location.x) {
                                    self.selectionPosition = xDomain.clamp(date)
                                }
                            }
                            
                            .onEnded { _ in
                                self.selectionPosition = nil
                            }
                    ) 
            }
        })
        .frame(height: 250)
    }
    
    func getFormattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "ru")
        
        return dateFormatter.string(from: date)
    }
}

#Preview {
    DetailsChartView()
        .environmentObject(DetailsController(ticker: "SBER"))
}
