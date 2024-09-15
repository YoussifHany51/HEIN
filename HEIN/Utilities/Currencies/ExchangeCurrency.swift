//
//  ExchangeCurrency.swift
//  HEIN
//
//  Created by Marco on 2024-09-15.
//

import Foundation

class ExchangeCurrency {
    static func exchangeCurrency(amount: String?) -> String {
        let result =  Float(amount ?? "0")! * Float(UserDefaults.standard.string(forKey: "factor") ?? "1")!
        return String(format: "%.2f", result)
    }
    
    static func getCurrency() -> String {
        return UserDefaults.standard.string(forKey: "currencyTitle") ?? "USD"
    }
}
