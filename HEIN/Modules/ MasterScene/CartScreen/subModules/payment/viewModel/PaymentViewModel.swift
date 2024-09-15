//
//  PaymentViewModel.swift
//  HEIN
//
//  Created by Marco on 2024-09-14.
//

import Foundation
import PassKit

class PaymentViewModel {
    let nwService: NetworkManager
    
    var paymentMethods = [(name: "Cash on delivery", image: "cash", isSelected: false), (name: "ApplePay", image: "applePay", isSelected: false)]
    
    var draftOrder: DraftOrder?
    
    let dummyLineItem: [String: Any] = ["title": "dummy", "quantity": 1, "price": "0.0", "properties":[]]
    
    func setSelectedPaymentMethodUI(selectedIndex: Int) {
        for index in 0..<paymentMethods.count {
            if index == selectedIndex {
                paymentMethods[index].isSelected = true
            } else {
                paymentMethods[index].isSelected = false
            }
        }
    }
    
    var bindResultToViewController: (() -> Void) = {}
    
    var flag: Bool = false {
        didSet {
            bindResultToViewController()
        }
    }
    
    init(draftOrder: DraftOrder?) {
        self.draftOrder = draftOrder
        nwService = NetworkManager()
    }
    
    func postOrder() {
        guard let draftOrder = draftOrder else {return}
        
        let lineItems = extractLineItemsOrderData(lineItems: filterLineItems(lineItems: draftOrder.lineItems))
        let customer = extractCustomerOrderData(customer: draftOrder.customer!)
        //let appliedDiscount = extractOrderDiscountData(discount: draftOrder.appliedDiscount!)
        let address = extractShippingAddressOrderData(address: draftOrder.shippingAddress!)
        let discount = draftOrder.appliedDiscount?.amount
        
        nwService.postWithResponse(url: APIHandler.urlForGetting(.orders), type: OrderResponse.self, parameters: ["order": [ "line_items": lineItems, "created_at": draftOrder.updatedAt, "currency": "EGP", "customer": customer], "shipping_address": address, "refund": ["transactions": ["amount": discount ?? "0.0"] ], "total_discounts": discount ?? "0.0"]) { orderResponse in
            
            guard orderResponse != nil else {return}
            self.clearDraftOrderItems()
        }
    }
    
    func extractLineItemsOrderData(lineItems: [LineItem]) -> [[String: Any]]{
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
    
    func extractCustomerOrderData(customer: CustomerModel) -> [String: Any]{
        var result: [String: Any] = [:]
//        result = ["id": customer.id!, "first_name": customer.first_name ?? "", "last_name": customer.last_name ?? "null", "email": customer.email ?? "", "phone": customer.phone ?? "", "tags": customer.tags ?? "null", "verified_email": customer.verified_email ?? "null", "note": customer.note ?? "" ]
        result = ["id": customer.id!]
        return result
    }
    
    func extractOrderDiscountData(discount: AppliedDiscount) -> [String: Any]{
        var result: [String: Any] = [:]
        result = ["title": discount.title, "description": discount.title, "value": discount.value, "value_type": discount.valueType, "amount": discount.amount]
        return result
    }
    
    func extractShippingAddressOrderData(address: shippingOrBillingAddress) -> [String: Any]{
        var result: [String: Any] = [:]
        result = ["address1": address.address1, "city": address.city, "country": address.country, "name": address.name, "phone": address.phone]
        return result
    }
    
    func clearDraftOrderItems() {
        guard let draftOrder = draftOrder else {return}
        nwService.putWithResponse(url: APIHandler.urlForGetting(.draftOrder(id: "\(draftOrder.id)")), type: DraftOrderContainer.self, parameters: ["draft_order":["line_items": [dummyLineItem], "applied_discount": nil ]]) { draftOrderContainer in
            
            self.flag = true
            print("Resuuuuuuuuuuuuuuuult: \(self.flag)")
        }
    }
    
    func configurePaymentRequest(request: PKPaymentRequest){
        request.merchantIdentifier = "HEIN.com.shopify.pay"
        request.supportedNetworks = [.masterCard, .visa]
        request.supportedCountries = ["EG", "US"]
        request.merchantCapabilities = .threeDSecure
        request.countryCode = "EG"
        request.currencyCode = UserDefaults.standard.string(forKey: "currencyTitle") ?? "USD"
    }
}
