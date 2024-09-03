//
//  Addresses.swift
//  HEIN
//
//  Created by Marco on 2024-09-03.
//

import Foundation

// MARK: - Addresses
struct Addresses: Codable {
    let addresses: [Address]
}

// MARK: - Address
struct Address: Codable {
    let id, customerID: Int
    let address1, city: String
    let phone, name: String
    let addressDefault: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case customerID = "customer_id"
        case address1, city, phone, name
        case addressDefault = "default"
    }
}
