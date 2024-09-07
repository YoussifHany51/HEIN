//
//  CurrencyViewModel.swift
//  HEIN
//
//  Created by Marco on 2024-09-07.
//

import Foundation

class CurrencyViewModel {
    
    let nwService : NetworkManager
    
    var bindResultToViewController: (() -> Void) = {}
    
    var allCurrencies : [(short: String, full: String)]? {
        didSet {
            bindResultToViewController()
        }
    }
    
    init() {
        nwService = NetworkManager()
        getCurrencies()
    }
    
    func getCurrencies() {
        nwService.fetch(url: APIHandler.currenciesUrl(.listOfAllCurrencies), type: CurrencyResponse.self) { responce in
            
            guard let responce = responce else {
                self.bindResultToViewController()
                return
            }

            self.allCurrencies = responce.currencies.map({ (key, value) in
                (short: key, full: value)
            })
        }
    }
    
    struct CurrencyResponse: Codable {
        let currencies : [String: String]
    }
    
}

