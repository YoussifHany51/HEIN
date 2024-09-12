//
//  checkoutViewModel.swift
//  HEIN
//
//  Created by Marco on 2024-09-13.
//

import Foundation

class CheckoutViewModel {
    let nwService : NetworkManager
    
    var customerId : Int
    
    var bindResultToViewController : (() -> Void) = {}
    
    var addresses : [Address]? {
        didSet {
            if let addresses = addresses {
                self.filterAddressesForDefault(addresses: addresses)
            } else {
                bindResultToViewController()
            }
        }
    }
    
    var defaultAddress : Address? {
        didSet {
            bindResultToViewController()
        }
    }
    
    init() {
        nwService = NetworkManager()
        // MARK: - change to be dynamic
        self.customerId = 8369844912424
    }
    
    func getAddresses() {
        nwService.fetch(url: APIHandler.urlForGetting(.allAddressesOf(customer_id: "\(customerId)")), type: Addresses.self) { response in
            
            guard let response = response else {
                return
            }

            self.addresses = response.addresses
        }
    }
    
    func filterAddressesForDefault(addresses: [Address]) {
        let defaultAddress = addresses.first { address in
                address.addressDefault == true
            }
        
        self.defaultAddress = defaultAddress
    }
}
