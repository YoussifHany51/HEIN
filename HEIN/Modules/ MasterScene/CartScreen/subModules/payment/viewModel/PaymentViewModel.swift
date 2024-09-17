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
        var discountCodes: [String : Any] = [:]
        if draftOrder.appliedDiscount != nil {
            discountCodes = extractOrderDiscountData(discount: draftOrder.appliedDiscount!)
        }
        let address = extractShippingAddressOrderData(address: draftOrder.shippingAddress!)
        //let discount = draftOrder.appliedDiscount!
        
        nwService.postWithResponse(url: APIHandler.urlForGetting(.orders), type: OrderResponse.self, parameters: ["order": [ "line_items": lineItems, "created_at": draftOrder.updatedAt, "currency": "EGP", "discount_codes": [discountCodes], "customer": customer], "shipping_address": address]) { orderResponse in
            
            guard orderResponse != nil else {return}
            self.clearDraftOrderItems()
            self.adjustInventory()
            if draftOrder.appliedDiscount != nil {
                self.removeCoupon(discount: draftOrder.appliedDiscount!)
            }
        }
    }
    
    func removeCoupon(discount: AppliedDiscount) {
        for i in 0...2 {
            if discount.description == UserDefaults.standard.string(forKey: "coupon\(i)") {
                UserDefaults.standard.set("used", forKey: "coupon\(i)")
                break
            }
        }
    }
    
    func adjustInventory() {
        guard let draftOrder = draftOrder else {return}
        let filterdLineItems = filterLineItems(lineItems: draftOrder.lineItems)
        print(filterdLineItems)
        
        for item in filterdLineItems {
            nwService.fetch(url: APIHandler.urlForGetting(.productVarient(id: "\(item.variantID ?? 0)")), type: VariantResponse.self) { variantResponse in
                
                self.nwService.postWithResponse(url: APIHandler.urlForGetting(.inventoryLevels), type: ProductType.self, parameters: ["location_id":100800790824, "inventory_item_id":variantResponse?.variant.inventoryItemID ?? 0,"available_adjustment":-item.quantity]) { rubish in
                    //
                }
            }
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
        result = ["code": discount.description, "value_type": discount.valueType, "amount": discount.amount]
        return result
    }
    
    func extractShippingAddressOrderData(address: shippingOrBillingAddress) -> [String: Any]{
        
        var coordinates: (latitude: String, longitude:String)?
        if let location = address.address2 {
            if location.contains("-") {
                coordinates = (latitude: "\(location.components(separatedBy: "-").first!)", longitude: "\(location.components(separatedBy: "-").last!)")
                print(coordinates!)
            }
        }
        
        var result: [String: Any] = [:]
        result = ["address1": address.address1, "city": address.city, "country": address.country, "name": address.name, "phone": address.phone, "latitude": "\(coordinates?.latitude ?? "")", "longitude": "\(coordinates?.longitude ?? "")"]
        
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
