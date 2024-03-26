//
//  StockSettingsSection.swift
//  SettingsScreenInSwiftUI
//
//  Created by Egor Anoshin on 26.03.2024.
//

import Foundation
import SwiftUI

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
                Image(systemName: "speedometer")
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
                Image(systemName: "bubble.middle.bottom")
                    .resizable()
                    .frame(width: 23, height: 23)
                Text("Bubbles scale")
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
                Text("Metric Info")
                Spacer()
                Image(systemName: "chevron.right")
            }
            .onTapGesture {
                self.showingMetricInfo = true
            }
            .sheet(isPresented: $showingMetricInfo) {
                MetricInfoView()
            }

            Divider()
            
            HStack {
                Image(systemName: "star.fill")
                    .resizable()
                    .frame(width: 23, height: 23)
                Text("Favorites")
                Spacer()
                Image(systemName: "chevron.right")
            }
            .padding(.vertical, 4)
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
                
                Text("Скользящее среднее – это статистический индикатор, который используется для определения среднего значения набора данных за определенный промежуток времени. Оно 'скользит', потому что с каждым новым периодом анализа предыдущие данные удаляются, а включаются новые.")
                    .padding(.bottom, 5)
                
                Text("Зачем это нужно:")
                    .font(.headline)
                    .padding(.bottom, 1)
                
                Text("Скользящее среднее помогает сгладить краткосрочные колебания и выявить долгосрочные тенденции. Оно широко используется в техническом анализе на финансовых рынках для анализа цен акций, валют и других финансовых инструментов.")
                    .padding(.bottom, 5)
                
                Text("Примеры использования:")
                    .font(.headline)
                    .padding(.bottom, 1)
                
                Text("1. Определение тренда: Восходящее скользящее среднее указывает на восходящий тренд, нисходящее – на нисходящий.\n\n2. Сигналы к покупке или продаже: Пересечение короткосрочного скользящего среднего с долгосрочным может служить сигналом к покупке (золотой крест) или продаже (смертельный крест).\n\n3. Уровни поддержки и сопротивления: Цены часто отскакивают от линий скользящего среднего, которые могут действовать как уровни поддержки или сопротивления.")
                    .padding(.bottom, 5)
            }
            .padding()
        }
    }
}

