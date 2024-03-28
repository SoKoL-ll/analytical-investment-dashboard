import Foundation
import SwiftUI

struct StockSettingsSection: View {
    @Binding var metricIndex: Int
    @Binding var bubblesIndex: Int
    let metricOptions: [String]
    @State private var showingMetricInfo = false
    @Binding var showingFavorites: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("STOCK SETTINGS")
                .font(.headline)
                .padding(.top, 10)
            Divider()
            
            HStack {
                Image(systemName: "dollarsign.circle")
                    .resizable()
                    .frame(width: 23, height: 23)
                Text("Main Metric")
                Spacer()
                Picker("Select", selection: $metricIndex) {
                    ForEach(0 ..< metricOptions.count, id: \.self) {
                        Text(self.metricOptions[$0])
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }

            Divider()
            
            HStack {
                Image(systemName: "bubbles.and.sparkles")
                    .resizable()
                    .frame(width: 23, height: 23)
                Text("Bubbles Scale")
                Spacer()
                Picker("Select", selection: $bubblesIndex) {
                    ForEach(0 ..< metricOptions.count, id: \.self) {
                        Text(self.metricOptions[$0])
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }

            Divider()
            
            HStack {
                Image(systemName: "info.circle")
                    .resizable()
                    .frame(width: 23, height: 23)
                Text("Metrics Info")
                Spacer()
                Image(systemName: "chevron.right")
            }
            .padding(.vertical, 5)
            .onTapGesture {
                self.showingMetricInfo = true
            }
            .sheet(isPresented: $showingMetricInfo) {
                MetricInfoView()
            }

            Divider()
            
            HStack {
                Image(systemName: "star")
                    .resizable()
                    .frame(width: 23, height: 23)
                Text("Favorites")
                Spacer()
                Image(systemName: "chevron.right")
            }
            .padding(.vertical, 5)
            .onTapGesture {
                // TickersView
                self.showingFavorites = true
            }
            .sheet(isPresented: $showingFavorites) {
                TickersView()
            }
            Divider()
        }
        .padding(.horizontal)
    }
}

// Metric Info
struct MetricInfoView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("Скользящее Среднее (Moving Average)")
                    .font(.title)
                    .padding(.bottom, 5)
                
                Text("Определение:")
                    .font(.headline)
                    .padding(.bottom, 1)
                
                Text("Скользящее среднее – это статистический индикатор, который используется для определения среднего значения.")
                    .padding(.bottom, 5)
                
                Text("Зачем это нужно:")
                    .font(.headline)
                    .padding(.bottom, 1)
                
                Text("Скользящее среднее помогает сгладить краткосрочные колебания.")
                    .padding(.bottom, 5)
                
                Text("Примеры использования:")
                    .font(.headline)
                    .padding(.bottom, 1)
                
                Text("Определение тренда: Восходящее скользящее среднее указывает на восходящий тренд")
                    .padding(.bottom, 5)
            }
            .padding()
        }
    }
}
