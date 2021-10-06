//
//  AppDelegate.swift
//  CryptoCurrencyTestApp
//
//  Created by Aba-Bakri Ibragimov on 1/10/21.
//

import Foundation
import Moya
import Moya_ObjectMapper

enum Manager {
    case getAllSymbols
    case getHistoryLatestData(symbol_id: String)
    case getSymbolsBySymbolId(symbol_id: String, exchange_id: String)
}

extension Manager: TargetType {
    var baseURL: URL {
        return URL(string: Constants.baseUrl)!
    }
    
    var path: String {
        switch self {
        case .getAllSymbols:
            return "v1/symbols/BINANCE"
        case .getHistoryLatestData(let symbol_id):
            return "v1/ohlcv/\(symbol_id)/latest"
        case .getSymbolsBySymbolId:
            return "v1/symbols"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getAllSymbols:
            return .requestPlain
        case .getHistoryLatestData:
            return .requestParameters(parameters: ["period_id": "10Day"], encoding: URLEncoding.queryString)
        case .getSymbolsBySymbolId(let symbol_id, let exchange_id):
            return .requestParameters(parameters: ["filter_symbol_id": symbol_id,
                                                   "filter_exchange_id": exchange_id ], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        let headers: [String: String] = ["Accept": "application/json",
                                         "Accept-Encoding": "deflate, gzip",
                                         "X-CoinAPI-Key": Constants.apiKey]
        return headers
    }
}
