//
//  AppDelegate.swift
//  CryptoCurrencyTestApp
//
//  Created by Aba-Bakri Ibragimov on 1/10/21.
//

import Foundation

enum DateFormat: String {
    /// Formatter digit format, e.g. `20.02.2020`.
    case ddMMyyyy = "dd.MM.yyyy"
    
    /// Formatter digit format, e.g. `20.02.20`.
    case ddMMyy = "dd/MM/yy"
    
    /// Formatter digit format, e.g. `2020-02-20`.
    case YYYY_MM_DD = "yyyy-MM-dd"
}

extension Date {
    func toString(dateFormat: DateFormat = .YYYY_MM_DD) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        dateFormatter.dateFormat = dateFormat.rawValue
        return dateFormatter.string(from: self)
    }
}

