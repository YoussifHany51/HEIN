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
    
    var bindProcessingErrorToViewController : (() -> Void) = {}
    
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
    
    var draftOrder : DraftOrder? {
        didSet {
            bindResultToViewController()
        }
    }
    
    init(draftOrder: DraftOrder?) {
        nwService = NetworkManager()
        // MARK: - change to be dynamic
        self.customerId = 8369844912424
        self.draftOrder = draftOrder
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
    
    func updateDraftOrderAddress() {
        guard let address = defaultAddress, let order = draftOrder else {
            return
        }
        
        nwService.putWithResponse(url: APIHandler.urlForGetting(.draftOrder(id: "\(order.id)")), type: DraftOrderContainer.self, parameters: ["draft_order":["shipping_address": ["first_name":"\(address.name)", "last_name":"", "address1":"\(address.address1)", "city":"\(address.city)", "country":"\(address.country)", "phone":"\(address.phone)"]]]) { draftOrderContainer in
            
            guard let draftOrderContainer = draftOrderContainer else {
                self.bindProcessingErrorToViewController()
                return
            }
            
            self.draftOrder = draftOrderContainer.draftOrder
        }
    }
}
