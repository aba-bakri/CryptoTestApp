//
//  AppDelegate.swift
//  CryptoCurrencyTestApp
//
//  Created by Aba-Bakri Ibragimov on 1/10/21.
//

import Foundation

class MainViewModel {
    private var service = Service.shared
    
    func getHistoryLatestData(symbol_id: String, completion: @escaping (Result<[HistoryLatestModel]>) -> Void) {
        service.getHistoryLatestData(symbol_id: symbol_id, completion: completion)
    }
    
    func getSymbolsBySymbolId(symbol_id: String, exchange_id: String, completion: @escaping (Result<[SymbolModel]>) -> Void) {
        service.getSymbolsBySymbolId(symbol_id: symbol_id, exchange_id: exchange_id, completion: completion)
    }
}
