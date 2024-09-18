//
//  CurrencyViewModel.swift
//  HEIN
//
//  Created by Marco on 2024-09-07.
//

import Foundation

class CurrencyViewModel {
    
    let nwService : NetworkManager
    
    var bindResultToViewController: (( _ result: ExchangeResult) -> Void) = {result in }
    
    enum ExchangeResult {
        case success
        case failure
    }
    
    var allCurrencies : [(short: String, full: String)]?
    
    init() {
        nwService = NetworkManager()
        allCurrencies = currencies.map({ (key, value) in
                (short: key, full: value)
            })
        //getCurrencies()
    }
    
    func getExchageRates(currency: String) {
        if currency == "USD" {
            UserDefaults.standard.setValue(1, forKey: "factor")
            UserDefaults.standard.setValue(currency, forKey: "currencyTitle")
            self.bindResultToViewController(.success)
            
            return
        }
        
        nwService.fetch(url: APIHandler.currenciesUrl(.liveCurrencies(wantedCurrencies: "\(currency),")), type: ExchangeRates.self, complitionHandler: { container in
            guard let container = container else {
                self.bindResultToViewController(.failure)
                return
            }
            UserDefaults.standard.setValue(container.quotes.first?.value, forKey: "factor")
            UserDefaults.standard.setValue(currency, forKey: "currencyTitle")
            self.bindResultToViewController(.success)
        }, headers: ["apiKey":APIHandler.currencyApiKey])
    }
    
    
    struct CurrencyResponse: Codable {
        let currencies : [String: String]
    }
    
}

