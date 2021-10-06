//
//  AppDelegate.swift
//  CryptoCurrencyTestApp
//
//  Created by Aba-Bakri Ibragimov on 1/10/21.
//

import Foundation
import UIKit
import Moya
import Moya_ObjectMapper
import Alamofire
import ObjectMapper

struct Constants {
    static let apiKey = "7ACD04DB-AB6B-4708-BC47-1FE658683BB8"
    static let baseUrl = "https://rest.coinapi.io/"
    static let socketUrl = "wss://ws.coinapi.io/v1/"
    static let surl = "wss://ws.coinapi.io/v1/ohlcv"
}

enum Result<T> {
    case success(T)
    case failure(String)
}

class Service {
    
    public let service = MoyaProvider<Manager>()
    public static let shared = Service()
    
    func getAllSymbols(completion: @escaping (Result<[SymbolModel]>) -> Void) {
        service.request(.getAllSymbols) { result in
            switch result {
            case .success(let response):
                do {
                    let model = try response.mapArray(SymbolModel.self)
                    completion(.success(model))
                } catch let error {
                    completion(.failure(error.localizedDescription))
                }
            case .failure(let error):
                completion(.failure(error.localizedDescription))
            }
        }
    }
    
    func getHistoryLatestData(symbol_id: String, completion: @escaping (Result<[HistoryLatestModel]>) -> Void) {
        service.request(.getHistoryLatestData(symbol_id: symbol_id)) { result in
            switch result {
            case .success(let response):
                do {
                    let model = try response.mapArray(HistoryLatestModel.self)
                    completion(.success(model))
                } catch let error {
                    completion(.failure(error.localizedDescription))
                }
            case .failure(let error):
                completion(.failure(error.localizedDescription))
            }
        }
    }
    
    func getSymbolsBySymbolId(symbol_id: String, exchange_id: String, completion: @escaping (Result<[SymbolModel]>) -> Void) {
        service.request(.getSymbolsBySymbolId(symbol_id: symbol_id, exchange_id: exchange_id)) { result in
            switch result {
            case .success(let response):
                do {
                    let model = try response.mapArray(SymbolModel.self)
                    completion(.success(model))
                } catch let error {
                    completion(.failure(error.localizedDescription))
                }
            case .failure(let error):
                completion(.failure(error.localizedDescription))
            }
        }
    }
    
}
