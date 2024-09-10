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
            let filteredDraft = filterLineItems(lineItems: draftOrder!.lineItems)
            draftOrder?.lineItems = filteredDraft
            bindResultToViewController()
        }
    }
    
    enum operation : String{
        case add
        case sub
    }
    
    let dummyLineItem: [String: Any] = ["title": "dummy", "quantity": 1, "price": "0.0", "properties":[]]
    
    init() {
        nwService = NetworkManager()
        // MARK: - Change to get from userDefaults
        self.draftOrderId = 1185874280744
    }
    
    func getDraftOrder() {
        nwService.fetch(url: APIHandler.urlForGetting(.draftOrder(id: "\(draftOrderId)")), type: DraftOrderContainer.self) { draftOrderContainer in
            
            self.draftOrder = draftOrderContainer?.draftOrder
        }
    }
    
    func updateDraftOrder(lineItems: [LineItem]) {
        nwService.putInApi(url: APIHandler.urlForGetting(.draftOrder(id: "\(draftOrderId)")), parameters: ["draft_order":["line_items": lineItems.count != 0 ? extractLineItemsPutData(lineItems: lineItems) : [dummyLineItem] ]])
    }
    
    func extractLineItemsPutData(lineItems: [LineItem]) -> [[String: Any]]{
        var result: [[String: Any]] = []
        for item in lineItems{
            var properties : [[String: String]] = []
            for property in item.properties {
                properties.append(["name":property.name, "value": property.value])
            }
            result.append(["variant_id": item.variantID!, "quantity": item.quantity, "properties": properties])
        }
                
        return result
    }
    
    func filterLineItems(lineItems: [LineItem]) -> [LineItem] {
        var filteredItems : [LineItem] = []
        for item in lineItems {
            if item.title != "dummy" {
                filteredItems.append(item)
            }
        }
        return filteredItems
    }
}
