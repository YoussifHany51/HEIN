//
//  File.swift
//  HEIN
//
//  Created by Marco on 2024-09-12.
//

import Foundation

class CouponsViewModel {
    let nwService: NetworkManager
    
    var bindResultToViewController: ((_ binding: Binding) -> Void) = {binding in }
    
    enum Binding: String {
        case appliedDiscount
        case priceRulesReady
    }
    
    var draftOrder: DraftOrder? {
        didSet {
            bindResultToViewController(.appliedDiscount)
        }
    }
    
    var draftOrderId : Int
    
    var priceRules: [PriceRule]? {
        didSet {
            bindResultToViewController(.priceRulesReady)
        }
    }
    
    init(draftOrder: DraftOrder) {
        self.nwService = NetworkManager()
        self.draftOrderId = Int(UserDefaults().string(forKey: "DraftOrder_Id") ?? "0")!
        self.draftOrder = draftOrder
        getPriceRules()
    }
    
    func getPriceRules() {
        nwService.fetch(url: APIHandler.urlForGetting(.priceRule), type: PriceRules.self) { priceRules in
            
            self.priceRules = priceRules?.priceRules
        }
    }
    
    func updateDraftOrder(priceRule: PriceRule) {
        nwService.putWithResponse(url: APIHandler.urlForGetting(.draftOrder(id: "\(draftOrderId)")), type: DraftOrderContainer.self, parameters: ["draft_order":["applied_discount": extractDiscountPutData(priceRule: priceRule) ]]) { draftOrderContainer in
            
            self.draftOrder = draftOrderContainer?.draftOrder
        }
    }
    
    func extractDiscountPutData(priceRule: PriceRule) -> [String: Any]{
        let result: [String: Any] = ["title": priceRule.title, "value_type": priceRule.valueType, "value": "\(priceRule.value.dropFirst())"]
        
        print(result)
                
        return result
    }
}
