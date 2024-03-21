//
//  NetworkManager.swift
//  AID
//
//  Created by Alexander on 20.03.2024.
//

import Foundation
import Alamofire

protocol NetworkManagerDescription {
    func getStocks(_ stockNames: [String], with indicatorType: IndicatorType, complition: @escaping (Result<[Stock], AIDError>) -> Void)
    func getStockIndicators(_ stockName: String, complition: @escaping (Result<[Indicator], AIDError>) -> Void)
    func getStockPrices(_ stockName: String, in timeDelta: TimeDelta, complition: @escaping (Result<[ChartData], AIDError>) -> Void)
}

class NetworkManager: NetworkManagerDescription {
    static let shared: NetworkManagerDescription = NetworkManager()
    private let baseURL = "http://ai-dashboard.site/"
    
    private init() {}
    
    func getStocks(_ stockNames: [String], with indicatorType: IndicatorType, complition: @escaping (Result<[Stock], AIDError>) -> Void) {
        let parameters: [String: String] = ["category": "return"]  // remove mock
        
        AF.request(baseURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)
            .responseDecodable(of: StockResponse.self) { response in
                print(response)  // remove print
            }
    }
    
    func getStockIndicators(_ stockName: String, complition: @escaping (Result<[Indicator], AIDError>) -> Void) {}
    
    func getStockPrices(_ stockName: String, in timeDelta: TimeDelta, complition: @escaping (Result<[ChartData], AIDError>) -> Void) {
        var chartDataArray: [ChartData] = []
        
        let pricesURL = "tickers/\(stockName)/chart"
        let parameters: [String: String] = ["period": "1\(timeDelta.description)"]  // add number + remove mock for number of timeDelta
        AF.request(baseURL + pricesURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)
            .responseDecodable(of: StockPricesResponse.self) { response in
                switch response.result {
                case .success(let stockPrices):
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    
                    for stockPrice in stockPrices.items {
                        let dateString = stockPrice.begin
                        guard let stockPriceDate = dateFormatter.date(from: dateString) else {
                            complition(.failure(.invalidData))
                            return
                        }
                        
                        let chartData = ChartData(date: stockPriceDate, value: stockPrice.value)
                        chartDataArray.append(chartData)
                    }
                    
                    complition(.success(chartDataArray))
                case .failure:
                    complition(.failure(.invalidResponse))
                }
            }
    }
}
