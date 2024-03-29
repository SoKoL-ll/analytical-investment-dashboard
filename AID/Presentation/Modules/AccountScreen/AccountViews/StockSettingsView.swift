import Foundation
import SwiftUI

struct StockSettingsSection: View {
    @Binding var metricIndex: String
    @ObservedObject var viewModel: StockSettingsViewModel
    @State private var showingMetricInfo = false
    @Binding var showingFavorites: Bool
    @StateObject var tickerViewModel = TickersViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("STOCK SETTINGS")
                .font(.headline)
                .padding(.top, 10)
            Divider()
            
            // Picker for Main Indicator
            if viewModel.isLoading {
                disabledPicker(title: String(localized: "Main Indicator"))
            } else {
                enabledPicker(title: String(localized: "Main Indicator"), selection: $metricIndex, options: viewModel.categories)
            }
            
            Divider()
            
            // Metrics Info
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
            
            // Favorites
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
                self.showingFavorites = true
            }
            .sheet(isPresented: $showingFavorites) {
                TickersView(viewModel: tickerViewModel)
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
    private func enabledPicker(title: String, selection: Binding<String>, options: [String]) -> some View {
        HStack {
            Image(systemName: "dollarsign.circle").resizable().frame(width: 23, height: 23)
            Text(title)
            Spacer()
            Picker("Select", selection: selection) {
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }.pickerStyle(MenuPickerStyle())
        }
    }
}
