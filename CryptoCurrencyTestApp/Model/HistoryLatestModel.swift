//
//  AppDelegate.swift
//  CryptoCurrencyTestApp
//
//  Created by Aba-Bakri Ibragimov on 1/10/21.
//

import Foundation
import ObjectMapper

struct HistoryLatestModel: Mappable {
    var time_period_start: String? = ""
    var time_period_end: String? = ""
    var time_open: String? = ""
    var time_close: String? = ""
    var price_close: Double? = .zero
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        time_period_start <- map["time_period_start"]
        time_period_end <- map["time_period_end"]
        time_open <- map["time_open"]
        time_close <- map["time_close"]
        price_close <- map["price_close"]
    }
}
