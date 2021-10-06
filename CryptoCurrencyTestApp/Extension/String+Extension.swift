//
//  AppDelegate.swift
//  CryptoCurrencyTestApp
//
//  Created by Aba-Bakri Ibragimov on 1/10/21.
//

import Foundation

extension String {
    func toDate(dateFormat: DateFormat? = .YYYY_MM_DD) -> Date? {
        let dateFormat = dateFormat
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat?.rawValue
        dateFormatter.timeZone = TimeZone.init(identifier: "GTM")
        let date = dateFormatter.date(from: String(self))
        return date
    }
    
    func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
