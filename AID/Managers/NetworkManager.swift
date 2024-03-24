//
//  NetworkManager.swift
//  AID
//
//  Created by Alexander on 20.03.2024.
//

import Foundation
import Alamofire

protocol NetworkManagerDescription {
    func getStocks(with indicatorType: String, complition: @escaping (Result<[Stock], AIDError>) -> Void)
    func getStockIndicators(_ stockName: String, complition: @escaping (Result<(String, [Indicator]), AIDError>) -> Void)
    func getStockPrices(_ stockName: String, in timeDelta: TimeDelta, complition: @escaping (Result<[ChartData], AIDError>) -> Void)
    func getCategories(complition: @escaping (Result<[String], AIDError>) -> Void)
}

final class NetworkManager: NetworkManagerDescription {
    static let shared: NetworkManagerDescription = NetworkManager()
    private lazy var snakeDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    private init() {}
    
    func getStocks(with indicatorType: String, complition: @escaping (Result<[Stock], AIDError>) -> Void) {
        guard let endpointURL = generateBasicAPIURL() else {
            complition(.failure(.invalidResponse))
            return
        }
        
        var stockArray: [Stock] = []
        let parameters: [String: String] = generateParameter(value: indicatorType.description, parameter: .category)
        AF.request(endpointURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)
            .responseDecodable(of: StockResponse.self, decoder: snakeDecoder) { response in
                switch response.result {
                case .success(let stocks):
                    for stock in stocks.items {
                        let indicator = Indicator(type: indicatorType, value: stock.value.value, postfix: stocks.postfix)
                        let stockElem = Stock(ticker: stock.key, indicator: indicator)
                        stockArray.append(stockElem)
                    }
                    
                    complition(.success(stockArray))
                case .failure:
                    complition(.failure(.invalidResponse))
                }
            }
    }
    
    func getStockIndicators(_ stockName: String, complition: @escaping (Result<(String, [Indicator]), AIDError>) -> Void) {
        guard let endpointURL = generateStockAPIURL(stockTicker: stockName, type: .indicators) else {
            complition(.failure(.invalidResponse))
            return
        }
        
        var indicatorArray: [Indicator] = []
        AF.request(endpointURL, method: .post)
            .responseDecodable(of: StockIndicatorsResponse.self, decoder: snakeDecoder) { response in
                switch response.result {
                case .success(let stockIndicators):
                    for indicator in stockIndicators.items {
                        let indicatorElem = Indicator(type: indicator.key,
                                                      value: indicator.value.value,
                                                      postfix: indicator.value.postfix, 
                                                      description: indicator.value.description,
                                                      shouldBuy: indicator.value.shouldBuy)
                        indicatorArray.append(indicatorElem)
                    }
                    
                    complition(.success((stockIndicators.tickerFullName, indicatorArray)))
                case .failure:
                    complition(.failure(.invalidResponse))
                }
            }
    }
    
    func getStockPrices(_ stockName: String, in timeDelta: TimeDelta, complition: @escaping (Result<[ChartData], AIDError>) -> Void) {
        guard let endpointURL = generateStockAPIURL(stockTicker: stockName, type: .prices) else {
            complition(.failure(.invalidResponse))
            return
        }
        
        var chartDataArray: [ChartData] = []
        let parameters: [String: String] = generateParameter(value: timeDelta.description, parameter: .period)
        AF.request(endpointURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)
            .responseDecodable(of: StockPricesResponse.self) { response in
                switch response.result {
                case .success(let stockPrices):
                    let dateFormatter: DateFormatter = {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = Constants.Dates.dateFormat
                        return dateFormatter
                    }()
                    
                    for stockPrice in stockPrices.items {
                        let beginDateString = stockPrice.begin
                        let endDateString = stockPrice.end
                        guard
                            let stockPriceBeginDate = dateFormatter.date(from: beginDateString),
                            let stockPriceEndDate = dateFormatter.date(from: endDateString)
                        else {
                            complition(.failure(.invalidData))
                            return
                        }
                        
                        let chartData = ChartData(open: stockPrice.open,
                                                  close: stockPrice.close,
                                                  high: stockPrice.high,
                                                  low: stockPrice.low,
                                                  begin: stockPriceBeginDate,
                                                  end: stockPriceEndDate)
                        chartDataArray.append(chartData)
                    }
                    
                    complition(.success(chartDataArray))
                case .failure:
                    complition(.failure(.invalidResponse))
                }
            }
    }
    
    func getCategories(complition: @escaping (Result<[String], AIDError>) -> Void) {
        guard let endpointURL = generateBasicAPIURL(endpoint: Constants.categoriesEndpoint) else {
            complition(.failure(.invalidResponse))
            return
        }
        
        AF.request(endpointURL, method: .post)
            .responseDecodable(of: CategoriesResponse.self) { response in
                switch response.result {
                case .success(let categories):
                    complition(.success(categories.categories))
                case .failure:
                    complition(.failure(.invalidResponse))
                }
            }
    }
}

private extension NetworkManager {
    func generateBasicAPIURL(endpoint: String? = nil) -> URL? {
        let baseURL = Constants.scheme + Constants.host
        var endpointURL = baseURL
        if let endpoint = endpoint {
            endpointURL += endpoint
        }
        return URL(string: endpointURL)
    }
    
    func generateStockAPIURL(stockTicker: String, type: TickerInfo) -> URL? {
        let baseURL = Constants.scheme + Constants.host
        let tickerURL = Constants.tickerPart + stockTicker + type.rawValue
        let endpointURL = baseURL + tickerURL
        return URL(string: endpointURL)
    }
    
    func generateParameter(value: String, parameter: Parameter) -> [String: String] {
        return [parameter.rawValue: value]
    }
    
    enum Parameter: String {
        case period
        case category
    }
    
    enum TickerInfo: String {
        case prices = "/chart"
        case indicators = "/values"
    }
    
    struct Constants {
        static let scheme = "http://"
        static let host = "ai-dashboard.site/"
        
        static let tickerPart = "tickers/"
        static let categoriesEndpoint = "categories"
        
        struct Dates {
            static let dateFormat = "yyyy-MM-dd HH:mm:ss"
        }
    }
}
