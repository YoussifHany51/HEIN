//
//  AddressesViewModel.swift
//  HEIN
//
//  Created by Marco on 2024-09-07.
//

import Foundation

class AddressesViewModel {
    let nwService : NetworkManager
    
    var bindResultToViewController: ((_ defaultAddress: Address) -> Void) = {address in }
    
    var customerId : Int
    
    init(customerId: Int) {
        nwService = NetworkManager()
        self.customerId = customerId
    }
    
    func SetDefaultAddress(address: Address) {
        nwService.putInApi(url: APIHandler.urlForGetting(.makeDefaultAddress(customer_id: "\(customerId)", address_id: "\(address.id)")))
        
        bindResultToViewController(address)
    }
}
