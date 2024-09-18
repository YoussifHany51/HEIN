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
    
    // MARK: change
    let discountCodes = [(code:"SUMMERSALE50FF", priceRuleId:1481131360552), (code:"SUMMERSALE20FF", priceRuleId:1481011790120),(code:"LAST10WAITING", priceRuleId:1482065740072)]
    
    func getPriceRules() {
        var userCoupons: [String] = []
        for i in 0...2 {
            if let coupon = UserDefaults.standard.string(forKey: "coupon\(i)"){
                if coupon != "used" {
                    userCoupons.append(coupon)
                }
            }
        }
        
        nwService.fetch(url: APIHandler.urlForGetting(.priceRule), type: PriceRules.self) { priceRules in
            
            self.priceRules = priceRules?.priceRules.filter({ priceRule in
                var isIn: Bool = false
                for code in self.discountCodes {
                    if priceRule.id == code.priceRuleId {
                        if let coupon = userCoupons.firstIndex(where: {$0 == code.code}) {
                            isIn = true
                        }
                    }
                }
                return isIn
            })
        }
    }
    
    func updateDraftOrder(priceRule: PriceRule, discountCode: String) {
        nwService.putWithResponse(url: APIHandler.urlForGetting(.draftOrder(id: "\(draftOrderId)")), type: DraftOrderContainer.self, parameters: ["draft_order":["applied_discount": extractDiscountPutData(priceRule: priceRule, discountCode: discountCode) ]]) { draftOrderContainer in
            
            self.draftOrder = draftOrderContainer?.draftOrder
        }
    }
    
    func extractDiscountPutData(priceRule: PriceRule, discountCode: String) -> [String: Any]{
        let result: [String: Any] = ["title": priceRule.title, "value_type": priceRule.valueType, "value": "\(priceRule.value.dropFirst())", "description": discountCode,]
        
        print(result)
                
        return result
    }
}
