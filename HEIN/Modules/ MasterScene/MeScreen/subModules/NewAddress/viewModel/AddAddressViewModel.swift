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
    
    var updatedAddress : Address? {
        didSet {
            bindResultToViewController(.update)
        }
    }
    
    enum addressOperation {
        case delete
        case addNew
        case update
    }
    
    init() {
        nwService = NetworkManager()
        self.customerId = Int(UserDefaults.standard.string(forKey: "User_id") ?? "0")!
    }
    
    func addNewAddress(street: String, city: String, country: String, phone: String, name: String, addressLocation: String?) {
        nwService.postWithResponse(url: APIHandler.urlForGetting(.allAddressesOf(customer_id: "\(customerId)")), type: CustomerAddressResponse.self, parameters: ["address":["address1":"\(street)","city":"\(city)","phone":"\(phone)","name":"\(name)","country": "\(country)","address2": "\(addressLocation ?? "Nothing")",]]) { response in
            self.newAddress = response?.customerAddress
        }
    }
    
    func deleteAddress(addressID: Int) {
        nwService.deleteFromApi(url: APIHandler.urlForGetting(.address(customer_id: "\(customerId)", address_id: "\(addressID)")))
        
        bindResultToViewController(.delete)
    }
    
    func UpdateAddress(addressID: Int, street: String, city: String, country: String, phone: String, name: String, addressLocation: String?) {
        nwService.putWithResponse(url: APIHandler.urlForGetting(.address(customer_id: "\(customerId)", address_id: "\(addressID)")), type: CustomerAddressResponse.self, parameters: ["address":["address1":"\(street)","city":"\(city)","phone":"\(phone)","name":"\(name)","country": "\(country)","address2": "\(addressLocation ?? "Nothing")"]]) { response in
            self.updatedAddress = response?.customerAddress
        }
    }
}
