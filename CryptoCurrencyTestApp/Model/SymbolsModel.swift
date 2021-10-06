//
//  AppDelegate.swift
//  CryptoCurrencyTestApp
//
//  Created by Aba-Bakri Ibragimov on 1/10/21.
//

import ObjectMapper

struct SymbolModel: Mappable {
    var symbol_id: String? = ""
    var exchange_id: String? = ""
    var symbol_type: String? = ""
    var asset_id_base: String? = ""
    var asset_id_quote: String? = ""
    var data_start: String? = ""
    var data_end: String? = ""
    var data_trade_start: String? = ""
    var data_trade_end: String? = ""
    var price: Double? = .zero
    
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        symbol_id <- map["symbol_id"]
        exchange_id <- map["exchange_id"]
        symbol_type <- map["symbol_type"]
        asset_id_base <- map["asset_id_base"]
        asset_id_quote <- map["asset_id_quote"]
        data_end <- map["data_end"]
        data_trade_start <- map["data_trade_start"]
        data_trade_end <- map["data_trade_end"]
        price <- map["price"]
    }
}
