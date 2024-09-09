//
//  CartScreenViewModel.swift
//  HEIN
//
//  Created by Marco on 2024-09-09.
//

import Foundation

class CartScreenViewModel {
    let nwService : NetworkManager
    
    var bindResultToViewController: (() -> Void) = {}
    
    var draftOrderId : Int
    
    var draftOrder : DraftOrder? {
        didSet {
            bindResultToViewController()
        }
    }
    
    enum operation : String{
        case add
        case sub
    }
    
    init() {
        nwService = NetworkManager()
        // MARK: - Change to get from userDefaults
        self.draftOrderId = 1185874280744
    }
    
    func getDraftOrder() {
        nwService.fetch(url: APIHandler.urlForGetting(.draftOrder(id: "\(draftOrderId)")), type: DraftOrderContainer.self) { draftOrderContainer in
            //guard let draftOrderContainer = draftOrderContainer else {return}
            self.draftOrder = draftOrderContainer?.draftOrder
        }
    }
    
    func updateDraftOrder(lineItems: [LineItem], operation: Operation) {
//        nwService.putInApi(url: APIHandler.urlForGetting(.draftOrder(id: draftOrderId)), parameters: ["draft_order":["line_items":lineItems]])
    }
}
