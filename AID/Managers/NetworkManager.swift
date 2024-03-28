//
//  NetworkManager.swift
//  AID
//
//  Created by Alexander on 20.03.2024.
//

import Foundation
import Alamofire

protocol NetworkManagerDescription {
    func getStocks(with indicatorType: String, completion: @escaping (Result<([Stock], [Index]), AIDError>) -> Void)
    func getStockIndicators(_ stockName: String, completion: @escaping (Result<StockInfo, AIDError>) -> Void)
    func getStockPrices(_ stockName: String, in timeDelta: TimeDelta, completion: @escaping (Result<[ChartData], AIDError>) -> Void)
    func getCategories(completion: @escaping (Result<[String], AIDError>) -> Void)
}

final class NetworkManager: NetworkManagerDescription {
    static let shared: NetworkManagerDescription = NetworkManager()
    private lazy var snakeDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.Dates.dateFormat
        return dateFormatter
    }()
    
    private init() {}
    
    func getStocks(with indicatorType: String, completion: @escaping (Result<([Stock], [Index]), AIDError>) -> Void) {
        guard let endpointURL = generateBasicAPIURL() else {
            completion(.failure(.invalidResponse))
            return
        }
        
        let parameters: [String: String] = generateParameter(value: indicatorType.description, parameter: .category)
        AF.request(endpointURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)
            .responseDecodable(of: StockResponse.self, decoder: snakeDecoder) { response in
                switch response.result {
                case .success(let stocks):
                    let stockArray: [Stock] = stocks.tickers.map { key, value in
                        let indicator = Indicator(type: indicatorType, value: value.value, postfix: stocks.postfix)
                        return Stock(ticker: key, indicator: indicator)
                    }
                    let indexArray: [Index] = stocks.indices.map { key, value in
                        let index = Index(shortName: key, fullName: value.name, tickers: value.tickers)
                        return index
                    }
                    
                    completion(.success((stockArray, indexArray)))
                case .failure:
                    completion(.failure(.invalidResponse))
                }
            }
    }
    
    func getStockIndicators(_ stockName: String, completion: @escaping (Result<StockInfo, AIDError>) -> Void) {
        guard let endpointURL = generateStockAPIURL(stockTicker: stockName, type: .indicators) else {
            completion(.failure(.invalidResponse))
            return
        }
        
        AF.request(endpointURL, method: .post)
            .responseDecodable(of: StockIndicatorsResponse.self, decoder: snakeDecoder) { response in
                switch response.result {
                case .success(let stockIndicators):
                    let indicatorArray: [Indicator] = stockIndicators.items.map { key, value in
                        return Indicator(type: key,
                                         value: value.value,
                                         postfix: value.postfix,
                                         name: value.name,
                                         description: value.description,
                                         verdict: value.verdict)
                    }
                    let stockInfo: StockInfo = .init(name: stockIndicators.shortName,
                                                     description: stockIndicators.fullName,
                                                     price: stockIndicators.price,
                                                     indicators: indicatorArray)
                    
                    completion(.success(stockInfo))
                case .failure:
                    completion(.failure(.invalidResponse))
                }
            }
    }
    
    func getStockPrices(_ stockName: String, in timeDelta: TimeDelta, completion: @escaping (Result<[ChartData], AIDError>) -> Void) {
        guard let endpointURL = generateStockAPIURL(stockTicker: stockName, type: .prices) else {
            completion(.failure(.invalidResponse))
            return
        }
        
        let parameters: [String: String] = generateParameter(value: timeDelta.description, parameter: .period)
        AF.request(endpointURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)
            .responseDecodable(of: StockPricesResponse.self) { [weak self] response in
                guard let self = self else {
                    return
                }
                
                switch response.result {
                case .success(let stockPrices):
                    let chartDataArray: [ChartData] = stockPrices.items.compactMap { [weak self] priceInfo in
                        guard
                            let self = self,
                            let stockPriceBeginDate = dateFormatter.date(from: priceInfo.begin),
                            let stockPriceEndDate = dateFormatter.date(from: priceInfo.end)
                        else {
                            return nil
                        }
                        
                        return ChartData(open: priceInfo.open,
                                         close: priceInfo.close,
                                         high: priceInfo.high,
                                         low: priceInfo.low,
                                         begin: stockPriceBeginDate,
                                         end: stockPriceEndDate)
                    }
                    
                    completion(.success(chartDataArray))
                case .failure:
                    completion(.failure(.invalidResponse))
                }
            }
    }
    
    func getCategories(completion: @escaping (Result<[String], AIDError>) -> Void) {
        guard let endpointURL = generateBasicAPIURL(endpoint: Constants.categoriesEndpoint) else {
            completion(.failure(.invalidResponse))
            return
        }
        
        AF.request(endpointURL, method: .post)
            .responseDecodable(of: CategoriesResponse.self) { response in
                switch response.result {
                case .success(let categories):
                    completion(.success(categories.categories))
                case .failure:
                    completion(.failure(.invalidResponse))
                }
            }
    }
}

private extension NetworkManager {
    
    // MARK: - Generating functions
    
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
    
    // MARK: - Request cases
    
    enum Parameter: String {
        case period
        case category
    }
    
    enum TickerInfo: String {
        case prices = "/chart"
        case indicators = "/values"
    }
    
    // MARK: - Constants
    
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
