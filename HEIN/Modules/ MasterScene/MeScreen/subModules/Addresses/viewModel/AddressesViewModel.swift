//
//  AddressesViewModel.swift
//  HEIN
//
//  Created by Marco on 2024-09-07.
//

import Foundation

class AddressesViewModel {
    let nwService : NetworkManager
    
    var bindDefaultAddressToViewController: ((_ defaultAddress: Address) -> Void) = {address in }
    
    var bindAddressesToViewController : (() -> Void) = {}
    
    var customerId : Int
    
    var addresses : [Address]? {
        didSet {
            bindAddressesToViewController()
        }
    }
    
    init() {
        nwService = NetworkManager()
        self.customerId = Int(UserDefaults.standard.string(forKey: "User_id") ?? "0")!
    }
    
    func SetDefaultAddress(address: Address) {
        nwService.putInApi(url: APIHandler.urlForGetting(.makeDefaultAddress(customer_id: "\(customerId)", address_id: "\(address.id)")))
        
        bindDefaultAddressToViewController(address)
    }
    
    func getAddresses() {
        nwService.fetch(url: APIHandler.urlForGetting(.allAddressesOf(customer_id: "\(customerId)")), type: Addresses.self) { response in
            
            guard let response = response else {
                return
            }

            self.addresses = response.addresses
        }
    }
}
