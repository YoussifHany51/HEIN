//
//  MeViewModel.swift
//  HEIN
//
//  Created by Marco on 2024-09-07.
//

import Foundation

class MeViewModel {
    let nwService : NetworkManager
    
    var bindResultToViewController: (() -> Void) = {}
    
    var customerId : Int
    
    var orders : [Order]?{
        didSet{
            bindResultToViewController()
        }
    }
    
    init(customerId: Int) {
        nwService = NetworkManager()
        self.customerId = customerId
    }
    
    func getOrders() {
        nwService.fetch(url: APIHandler.urlForGetting(.orders), type: Orders.self) { responce in
            
            guard let responce = responce else {
                self.bindResultToViewController()
                return
            }

            self.orders = responce.orders.filter({ order in
                order.customer.id == self.customerId
            })
        }
    }
}

