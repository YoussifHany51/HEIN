//
//  ExchangeRates.swift
//  HEIN
//
//  Created by Marco on 2024-09-03.
//

import Foundation

// MARK: - ExchangeRates
struct ExchangeRates: Codable {
    let success: Bool
    let timestamp: Int
    let source: String
    let quotes: [String: Double]
}
