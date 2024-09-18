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
        self.customerId = Int(UserDefaults().string(forKey: "User_id") ?? "0")!
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
        
        var coordinates: (latitude: String, longitude:String)?
        
        if let location = address.address2 {
            if location.contains("-") {
                coordinates = (latitude: "\(location.components(separatedBy: "-").first!)", longitude: "\(location.components(separatedBy: "-").last!)")
                print(coordinates!)
            }
        }
        
        nwService.putWithResponse(url: APIHandler.urlForGetting(.draftOrder(id: "\(order.id)")), type: DraftOrderContainer.self, parameters: ["draft_order":["shipping_address": ["first_name":"\(address.name)", "last_name":"", "address1":"\(address.address1)", "address2":"\(address.address2 ?? "")", "city":"\(address.city)", "country":"\(address.country)", "phone":"\(address.phone)", "latitude": "\(coordinates?.latitude ?? "")", "longitude": "\(coordinates?.longitude ?? "")" ]]]) { draftOrderContainer in
            
            guard let draftOrderContainer = draftOrderContainer else {
                self.bindProcessingErrorToViewController()
                return
            }
            
            self.draftOrder = draftOrderContainer.draftOrder
        }
    }
}
