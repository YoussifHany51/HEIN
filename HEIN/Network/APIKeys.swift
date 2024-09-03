//
//  APIKeys.swift
//  HEIN
//
//  Created by Marco on 2024-09-02.
//

import Foundation

protocol APIKeysProtocol {
    var accessToken : String {get}
    var apiKey : String {get}
    var apiSecretKey : String {get}
    var currencyApiKey : String {get}
}

struct APIKeys : APIKeysProtocol {
    static var shared = APIKeys()
    
    let dict : NSDictionary
    
    private enum Keys : String {
        case accessToken
        case apiKey
        case apiSecretKey
        case currencyApiKey
    }
    
    private init() {
        guard let filePath = Bundle.main.path(forResource: "API-Keys", ofType: "plist"),
            let pList = NSDictionary(contentsOfFile: filePath) else {
            fatalError("Couldn't find a file named API-Keys")
        }
        dict = pList
    }
    
    var accessToken : String {
        dict.object(forKey: Keys.accessToken.rawValue) as! String
    }
    
    var apiKey: String {
        dict.object(forKey: Keys.apiKey.rawValue) as! String
    }
    
    var apiSecretKey: String {
        dict.object(forKey: Keys.accessToken.rawValue) as! String
    }
    
    var currencyApiKey: String {
        dict.object(forKey: Keys.currencyApiKey.rawValue) as! String
    }
    
}
