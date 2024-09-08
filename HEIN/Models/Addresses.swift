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

struct CustomerAddressResponse: Codable {
    let customerAddress: Address
    
    enum CodingKeys: String, CodingKey {
        case customerAddress = "customer_address"
    }
}

// MARK: - Address
struct Address: Codable {
    let id, customerID: Int
    let address1, city: String
    let phone, name: String
    let country: String
    var addressDefault: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case customerID = "customer_id"
        case address1, city, phone, name
        case country
        case addressDefault = "default"
    }
}
