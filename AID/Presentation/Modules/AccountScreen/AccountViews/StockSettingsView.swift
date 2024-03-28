import Foundation
import SwiftUI

struct StockSettingsSection: View {
    @Binding var metricIndex: Int
    @Binding var bubblesIndex: Int
    @ObservedObject var viewModel: StockSettingsViewModel
    @State private var showingMetricInfo = false
    @Binding var showingFavorites: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("STOCK SETTINGS")
                .font(.headline)
                .padding(.top, 10)
            Divider()
            
            if viewModel.isLoading {
                            disabledPicker(title: "Main Indicator")
                        } else {
                            enabledPicker(title: "Main Indicator", selection: $metricIndex, options: viewModel.categories)
                        }

            Divider()
            
            if viewModel.isLoading {
                            disabledPicker(title: "Bubbles Scale")
                        } else {
                            enabledPicker(title: "Bubbles Scale", selection: $bubblesIndex, options: viewModel.categories)
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
        @ViewBuilder
        private func disabledPicker(title: String) -> some View {
            HStack {
                Image(systemName: "dollarsign.circle")
                    .resizable()
                    .frame(width: 23, height: 23)
                Text(title)
                Spacer()
                Picker("", selection: .constant(0)) {
                    Text("Loading...").tag(0)
                }
                .pickerStyle(MenuPickerStyle())
                .disabled(true)
            }
        }

        // Активный пикер с загруженными данными
        private func enabledPicker(title: String, selection: Binding<Int>, options: [String]) -> some View {
            HStack {
                Image(systemName: "dollarsign.circle")
                    .resizable()
                    .frame(width: 23, height: 23)
                Text(title)
                Spacer()
                Picker("Select", selection: selection) {
                    ForEach(0..<options.count, id: \.self) {
                        Text(options[$0])
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
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
