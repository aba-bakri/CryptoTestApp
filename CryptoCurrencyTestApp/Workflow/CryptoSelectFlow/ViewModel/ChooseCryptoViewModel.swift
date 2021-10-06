//
//  AppDelegate.swift
//  CryptoCurrencyTestApp
//
//  Created by Aba-Bakri Ibragimov on 1/10/21.
//

import Foundation

class ChooseCryptoViewModel {
    private var service = Service.shared

    func getAllSymbols(completion: @escaping (Result<[SymbolModel]>) -> Void) {
        service.getAllSymbols(completion: completion)
    }
}
