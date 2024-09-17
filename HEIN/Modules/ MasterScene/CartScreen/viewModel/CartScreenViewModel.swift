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
            if draftOrder != nil {
                let filteredLineItems = filterLineItems(lineItems: draftOrder!.lineItems)
                self.lineItems = filteredLineItems
                if filteredLineItems.count != 0 {
                    self.getProductVariants(lineItems: filteredLineItems)
                } else {
                    bindResultToViewController()
                }
                
            } else {
                bindResultToViewController()
            }
        }
    }
    
    var lineItems: [LineItem]?
    
    var variantsStock : [(id: Int, stock: Int)] = [] {
        didSet {
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
        //self.draftOrderId =  1186489467176
        self.draftOrderId = Int(UserDefaults().string(forKey: "DraftOrder_Id") ?? "0")!
    }
    
    func getDraftOrder() {
        nwService.fetch(url: APIHandler.urlForGetting(.draftOrder(id: "\(draftOrderId)")), type: DraftOrderContainer.self) { draftOrderContainer in
            
            self.draftOrder = draftOrderContainer?.draftOrder
        }
    }
    
    func updateDraftOrderLineItems(lineItems: [LineItem]) {
        nwService.putWithResponse(url: APIHandler.urlForGetting(.draftOrder(id: "\(draftOrderId)")), type: DraftOrderContainer.self, parameters: ["draft_order":["line_items": lineItems.count != 0 ? extractLineItemsPutData(lineItems: lineItems) : [dummyLineItem] ]]) { draftOrderContainer in
            
            self.draftOrder = draftOrderContainer?.draftOrder
        }
    }
    
    func removeDraftOrderAppliedDiscount() {
        nwService.putWithResponse(url: APIHandler.urlForGetting(.draftOrder(id: "\(draftOrderId)")), type: DraftOrderContainer.self, parameters: ["draft_order":["applied_discount": ["value":"0.0"]]]) { draftOrderContainer in
            
            self.draftOrder = draftOrderContainer?.draftOrder
        }
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
    
    func getProductVariants(lineItems: [LineItem]) {
        var producIDs : String = ""
        for item in lineItems {
            producIDs.append(",\(item.productID ?? 0)")
        }
        nwService.fetch(url: "\(APIHandler.urlForGetting(.products))?ids=\(producIDs)", type: Products.self) { products in
            self.getVariantsStock(products: products?.products ?? [])
        }
    }
    
    func getVariantsStock(products: [Product]){
        let variants = products.map { product in
                return product.variants
            }
        
        var Stock : [(id: Int, stock: Int)] = []
        
        for i in 0..<(lineItems?.count ?? 0) {
            for variant in variants[i] {
                if self.lineItems?[i].variantID == variant.id {
                    Stock.append((id: variant.id, stock: variant.inventoryQuantity))
                }
            }
        }
        self.variantsStock = Stock
    }
}
