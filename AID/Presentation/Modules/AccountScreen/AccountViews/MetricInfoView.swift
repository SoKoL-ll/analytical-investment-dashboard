//
//  MetricInfoView.swift
//  AID
//
//  Created by Egor Anoshin on 29.03.2024.
//

import Foundation
import SwiftUI

struct MetricInfoView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(IndicatorInfoTest.allCases, id: \.self) { info in
                    Text(info.title)
                        .font(.title2)
                        .bold()
                        .padding(.vertical, 2)
                    
                    Text(info.description)
                        .padding(.bottom, 5)
                }
            }
            .padding()
        }
    }
}

enum IndicatorInfoTest: CaseIterable {
    case profitability, absDiv, relDiv, atr, rsi, percR, trix, value, sma, ema

    var title: String {
        switch self {
        case .profitability: return "1. Profitability Рентабельность"
        case .absDiv: return "2. ABS-DIV Абсолютное отклонение"
        case .relDiv: return "3. REL-DIV Относительное отклонение"
        case .atr: return "4. ATR Средний истинный диапазон"
        case .rsi: return "5. RSI Индекс относительной силы"
        case .percR: return "6. Perc-R Процентный диапазон Уильямса"
        case .trix: return "7. TRIX Осциллятор Трикс"
        case .value: return "8. Value Текущая стоимость"
        case .sma: return "9. SMA Простое скользящее среднее"
        case .ema: return "10. EMA Экспоненциальное скользящее среднее"
        }
    }

    var description: String {
        switch self {
        case .profitability:
            return "Измеряет эффективность инвестиции или сравнивает эффективность разных инвестиций."
        case .absDiv:
            return "Показывает абсолютную разницу между двумя переменными."
        case .relDiv:
            return "Представляет относительное изменение между двумя значениями."
        case .atr:
            return "Измеряет волатильность рынка."
        case .rsi:
            return "Определяет перекупленные или перепроданные условия на рынке."
        case .percR:
            return "Измеряет уровень текущих цен в диапазоне между максимумом и минимумом."
        case .trix:
            return "Показывает процентное изменение трехкратного экспоненциального скользящего среднего."
        case .value:
            return "Отражает текущую рыночную стоимость актива."
        case .sma:
            return "Представляет собой среднее значение цены за определенный период дней, сглаживая краткосрочные колебания и выявляя тренд."
        case .ema:
            return "Похоже на SMA, но дает больший вес последним данным, быстрее реагирует на изменения цены."
        }
    }
}
