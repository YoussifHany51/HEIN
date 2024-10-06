//
//  ProductInfoViewModel.swift
//  HEIN
//
//  Created by Youssif Hany on 16/09/2024.
//

import Foundation

class ProductInfoViewModel{
    var nwService = NetworkManager()
    var draftOrder : DraftOrder?{
        didSet{
            lineItems = draftOrder?.lineItems
        }
    }
    var lineItems : [LineItem]?
    func getDraftOrder() {
        nwService.fetch(url: APIHandler.urlForGetting(.draftOrder(id: UserDefaults().string(forKey: "DraftOrder_Id") ?? "")), type: DraftOrderContainer.self) { draftOrderContainer in
            self.draftOrder = draftOrderContainer?.draftOrder
        }
    }
    
    func extractLineItemsPutData(lineItems: [LineItem]) -> [[String: Any]]{
            let filterdItems = filterLineItems(lineItems: lineItems)
            print("LineItem\n")
            print(lineItems)
            var result: [[String: Any]] = []
            for item in filterdItems{
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
