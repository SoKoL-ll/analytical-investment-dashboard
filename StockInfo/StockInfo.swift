//
//  StockInfo.swift
//  StockInfo
//
//  Created by Alexander on 25.03.2024.
//

import WidgetKit
import SwiftUI
import Alamofire

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> StockInfoEntry {
        Constants.Default.widgetEntry
    }
    
    func getSnapshot(in context: Context, completion: @escaping (StockInfoEntry) -> Void) {
        completion(Constants.Default.widgetEntry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<StockInfoEntry>) -> Void) {
        getStock("YNDX", with: "profitability") { result in
            switch result {
            case .success(let stockInfoWidgetModelNew):
                completion(.init(entries: [.init(date: Date(), widgetData: stockInfoWidgetModelNew)], policy: .never))
            case .failure:
                completion(.init(entries: [Constants.Default.widgetEntry], policy: .never))
            }
        }
    }
}

struct StockInfoEntry: TimelineEntry {
    var date: Date
    var widgetData: StockInfoWidgetModelNew
}

struct StockInfoEntryView: View {
    var entry: Provider.Entry
    
    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .leading) {
                HStack {
                    entry.widgetData.image
                        .resizable()
                        .frame(width: Constants.Logo.size, height: Constants.Logo.size)
                        .clipShape(Circle())
                    Spacer()
                }
                
                Text("\(entry.widgetData.model.ticker) ")
                    .bold()
                + Text(entry.widgetData.model.fullName)
                    .font(.caption)
                    .foregroundStyle(.gray)
                
                Text(entry.widgetData.model.price)
                    .bold()
                Text("\(entry.widgetData.model.indicator)\(entry.widgetData.model.indicatorPostfix)")
                    .foregroundStyle(entry.widgetData.model.isPositive ? Constants.positiveColor : Constants.negativeColor)
            }
        }
    }
}

struct StockInfo: Widget {
    let kind: String = "StockInfo"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            StockInfoEntryView(entry: entry)
                .containerBackground(.background, for: .widget)
        }
        .configurationDisplayName("Stock info Widget")
        .description("Some information about your favorite stock.")
//        .supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    StockInfo()
} timeline: {
    Constants.Default.widgetEntry
}

func getStock(_ stockTicker: String, with indicatorName: String, complition: @escaping (Result<StockInfoWidgetModelNew, AIDError>) -> Void) {
    var image = Constants.Default.image
    var model = Constants.Default.model
    
    let globalQueue = DispatchQueue.global()
    let group = DispatchGroup()
    
    let indicatorWorkItem = DispatchWorkItem {
        getStockIndicators(stockTicker, indicatorName: indicatorName) { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let stockInfoWidgetModel):
                model = stockInfoWidgetModel
            case .failure:
                model = Constants.Default.model
            }
        }
    }
    
    let logoWorkItem = DispatchWorkItem {
        dowloadLogo(of: stockTicker) { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let logoImage):
                image = logoImage
            case .failure:
                image = Constants.Default.image
            }
        }
    }
    
    group.enter()
    globalQueue.async(execute: indicatorWorkItem)
    group.enter()
    globalQueue.async(execute: logoWorkItem)
    
    group.notify(queue: DispatchQueue.main) {
        let newModel: StockInfoWidgetModelNew = .init(model: model, image: image)
        complition(.success(newModel))
    }
}

func getStockIndicators(_ stockName: String, indicatorName: String, complition: @escaping (Result<StockInfoWidgetModel, AIDError>) -> Void) {
    let endpointURL = "http://ai-dashboard.site/tickers/\(stockName)/values"
    
    let snakeDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    AF.request(endpointURL, method: .post)
        .responseDecodable(of: StockIndicatorsResponse.self, decoder: snakeDecoder) { response in
            switch response.result {
            case .success(let stockIndicators):
                guard
                    let indicator = stockIndicators.items[indicatorName],
                    let indicatorValue = indicator.value
                else {
                    complition(.failure(.invalidData))
                    return
                }
                
                let indicatorPostfix = indicator.postfix
                let roundedIndicatorValue = String(format: Constants.IndicatorValue.format, indicatorValue)
                let priceString = Constants.Default.pricePrefix + String(stockIndicators.price)
                let isPositive = indicatorValue.sign == .plus ? true : false
                let stockInfo = StockInfoWidgetModel(
                    ticker: stockName,
                    fullName: stockIndicators.shortName,
                    price: priceString, isPositive: isPositive,
                    indicator: roundedIndicatorValue,
                    indicatorPostfix: indicatorPostfix
                )
                
                complition(.success(stockInfo))
            case .failure:
                complition(.failure(.invalidResponse))
            }
        }
}

func dowloadLogo(of stockTicker: String, completion: @escaping (Result<Image, AIDError>) -> Void) {
    let endpointURL = "http://ai-dashboard.site/images/\(stockTicker).png"
    
    guard
        let imageURL = URL(string: endpointURL),
        let data = try? Data(contentsOf: imageURL),
        let imageData = UIImage(data: data)
    else {
        completion(.failure(.invalidData))
        return
    }
    
    completion(.success(Image(uiImage: imageData)))
}

private struct Constants {
    static let negativeColor: Color = Color("Red")
    static let positiveColor: Color = Color("Green")
    
    struct Logo {
        static let size: CGFloat = 40.0
    }
    
    struct IndicatorValue {
        static let format = "%.3f"
    }
    
    struct Default {
        static let model: StockInfoWidgetModel = {
            let model = StockInfoWidgetModel(
                ticker: "AID",
                fullName: "AID",
                price: "₽123.45",
                isPositive: true,
                indicator: "+0.67",
                indicatorPostfix: "%"
            )
            return model
        }()
        
        static let widgetEntry: StockInfoEntry = {
            let image = Image("DefaultImage")
            let model = StockInfoWidgetModel(
                ticker: "AID",
                fullName: "AID",
                price: "₽123.45",
                isPositive: true,
                indicator: "+0.67",
                indicatorPostfix: "%"
            )
            return StockInfoEntry(date: Date(), widgetData: .init(model: model, image: image))
        }()
        
        static let image = Image("DefaultImage")
        
        static let pricePrefix = "₽"
    }
}
