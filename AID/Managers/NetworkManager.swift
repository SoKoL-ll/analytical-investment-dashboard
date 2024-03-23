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

class NetworkManager: NetworkManagerDescription {
    static let shared: NetworkManagerDescription = NetworkManager()
    private let baseURL = "http://ai-dashboard.site/"
    
    private init() {}
    
    func getStocks(with indicatorType: String, complition: @escaping (Result<[Stock], AIDError>) -> Void) {
        var stockArray: [Stock] = []
        
        let parameters: [String: String] = ["category": indicatorType.description]
        let decoder: JSONDecoder = {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return decoder
        }()
        AF.request(baseURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)
            .responseDecodable(of: StockResponse.self, decoder: decoder) { response in
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
        var indicatorArray: [Indicator] = []
        
        let indicatorsURL = "tickers/\(stockName)/values"
        let decoder: JSONDecoder = {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return decoder
        }()
        AF.request(baseURL + indicatorsURL, method: .post)
            .responseDecodable(of: StockIndicatorsResponse.self, decoder: decoder) { response in
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
        var chartDataArray: [ChartData] = []
        
        let pricesURL = "tickers/\(stockName)/chart"
        let parameters: [String: String] = ["period": timeDelta.description]
        AF.request(baseURL + pricesURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)
            .responseDecodable(of: StockPricesResponse.self) { response in
                switch response.result {
                case .success(let stockPrices):
                    let dateFormatter: DateFormatter = {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
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
        let categoriesURL = "categories"
        AF.request(baseURL + categoriesURL, method: .post)
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
