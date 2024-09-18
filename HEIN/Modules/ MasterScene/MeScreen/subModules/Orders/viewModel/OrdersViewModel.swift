//  OrdersViewModel.swift
//  HEIN
//  Created by Marco on 2024-09-07.


import Foundation

class OrdersViewModel {
    let nwService : NetworkManager
    
    var bindResultToViewController: (() -> Void) = {}
    
    var customerId : Int
    
    var orders : [Order]? {
        didSet {
            bindResultToViewController()
        }
    }
    
    init() {
        nwService = NetworkManager()
        self.customerId = Int(UserDefaults.standard.string(forKey: "User_id") ?? "0")!
    }
    
    func getOrders() {
        nwService.fetch(url: APIHandler.urlForGetting(.orders), type: Orders.self) { response in
            
            guard let response = response else {
                return
            }

            self.orders = response.orders.filter({ order in
                order.customer.id == self.customerId
            })
        }
    }
}
