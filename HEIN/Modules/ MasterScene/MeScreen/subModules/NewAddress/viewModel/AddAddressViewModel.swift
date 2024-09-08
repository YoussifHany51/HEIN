//
//  File.swift
//  HEIN
//
//  Created by Marco on 2024-09-08.
//

import Foundation
import Alamofire

class AddAddressViewModel {
    let nwService : NetworkManager
    
    var customerId : Int
    
    var bindResultToViewController : ((_ operation: addressOperation) -> Void) = {operation in }
    
    var newAddress : Address? {
        didSet {
            bindResultToViewController(.addNew)
        }
    }
    
    enum addressOperation {
        case delete
        case addNew
        case update
    }
    
    init(customerId: Int) {
        nwService = NetworkManager()
        self.customerId = customerId
    }
    
    func addNewAddress(street: String, city: String, country: String, phone: String, name: String) {
        nwService.postWithResponse(url: APIHandler.urlForGetting(.allAddressesOf(customer_id: "\(customerId)")), type: CustomerAddressResponse.self, parameters: ["address":["address1":"\(street)","city":"\(city)","phone":"\(phone)","name":"\(name)","country": "\(country)"]]) { response in
            self.newAddress = response?.customerAddress
        }
    }
    
    func deleteAddress(addressID: Int) {
        nwService.deleteFromApi(url: APIHandler.urlForGetting(.address(customer_id: "\(customerId)", address_id: "\(addressID)")))
        
        bindResultToViewController(.delete)
    }
    
    func UpdateAddress(addressID: Int, street: String, city: String, country: String, phone: String, name: String) {
        nwService.putInApi(url: APIHandler.urlForGetting(.address(customer_id: "\(customerId)", address_id: "\(addressID)")), parameters: ["address":["address1":"\(street)","city":"\(city)","phone":"\(phone)","name":"\(name)","country": "\(country)"]])
        
        bindResultToViewController(.update)
    }
}
