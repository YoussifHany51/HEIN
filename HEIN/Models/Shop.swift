//
//  Shop.swift
//  HEIN
//
//  Created by Marco on 2024-09-03.
//

import Foundation
// MARK: - ShopConfiguration
struct ShopConfiguration: Codable {
    let shop: Shop
}

// MARK: - Shop
struct Shop: Codable {
    let id: Int
    let name, email, domain: String
    let country: String
    let createdAt, updatedAt: Date
    let countryCode, countryName, currency, customerEmail: String
    let timezone, ianaTimezone, shopOwner, moneyFormat: String
    let moneyWithCurrencyFormat, weightUnit: String
    

    enum CodingKeys: String, CodingKey {
        case id, name, email, domain, country
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case countryCode = "country_code"
        case countryName = "country_name"
        case currency
        case customerEmail = "customer_email"
        case timezone
        case ianaTimezone = "iana_timezone"
        case shopOwner = "shop_owner"
        case moneyFormat = "money_format"
        case moneyWithCurrencyFormat = "money_with_currency_format"
        case weightUnit = "weight_unit"
    }
}

