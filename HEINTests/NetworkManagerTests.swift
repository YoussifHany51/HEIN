//
//  NetworkManagerTests.swift
//  E-CommerceAppTests
//
//  Created by Ahmed Abu-zeid on 28/02/2024.
//

import XCTest

@testable import HEIN

final class NetworkManagerTests: XCTestCase {

    var networkManager :NetworkManager?
    let dummyCustomerId = "8416898973992"
    let dummyName = "toni kross"
    
    override func setUpWithError() throws {
        networkManager = NetworkManager()
    }

    override func tearDownWithError() throws {
        networkManager = nil
    }

    func testFetchingToPass(){
        
        let expectation = self.expectation(description: "Network request expectation")
        let apiUrl = APIHandler.urlForGetting(.products)
        networkManager?.fetch(url: apiUrl, type: Products.self) { result in
            XCTAssertNotNil(result, "productsContainer came empty")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 30, handler: nil)
    }
    func testFetchingToFail(){
        let expectation = self.expectation(description: "Network request expectation")
        let apiUrl = "https://\(APIKeys.shared.apiKey):\(APIKeys.shared.accessToken)@nciost2.myshopify.com/admin/api/2024-07/produ.json"
        networkManager?.fetch(url: apiUrl, type: Products.self) { productsContainer in
            XCTAssertNil(productsContainer, "productsContainer came empty")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 30, handler: nil)
    }
    func testFetchingfaildecoding(){
        
        let expectation = self.expectation(description: "Network request expectation")
        let apiUrl = APIHandler.urlForGetting(.products)
        networkManager?.fetch(url: apiUrl, type: Customer.self) { productsContainer in
            XCTAssertNil(productsContainer, "productsContainer came empty")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 30, handler: nil)
    }

    func testPostFunction(){
        let expectation = self.expectation(description: "Network request expectation")
        let apiUrl = APIHandler.urlForGetting(.allAddressesOf(customer_id: dummyCustomerId))
        let parameters = ["address":["name": "toni kross", "phone": "44521", "address1": "Munich", "city": "Munich", "country": "Germany"]]
        networkManager?.PostToApi(url: apiUrl, parameters: parameters)
        Thread.sleep(forTimeInterval: 3)
        networkManager?.fetch(url: APIHandler.urlForGetting(.allAddressesOf(customer_id: dummyCustomerId)), type: Addresses.self) { addressesContainer in
            XCTAssert(addressesContainer?.addresses.last?.name == "toni kross", "Post function not working properly")
                    expectation.fulfill()
        }
        waitForExpectations(timeout: 30, handler: nil)
        
    }
    
    func testPutFunction(){
        let expectation = self.expectation(description: "Network request expectation")
        var addressID: String?
        let queue = DispatchQueue(label: "Serially Do")
        queue.async {
            let group = DispatchGroup()
            
            group.enter()
            self.networkManager?.fetch(url: APIHandler.urlForGetting(.allAddressesOf(customer_id: self.dummyCustomerId)), type: Addresses.self) { addressesContainer in
                for address in (addressesContainer?.addresses) ?? [] {
                    if address.name == self.dummyName {
                        print("\(address.name) assigninig id")
                        addressID = String(address.id)
                        group.leave()
                        break
                    }
                }
            }
            group.wait()
            
            let apiUrl = APIHandler.urlForGetting(.makeDefaultAddress(customer_id: self.dummyCustomerId, address_id: addressID ?? ""))
            self.networkManager?.putInApi(url: apiUrl)
            
            group.enter()
            Thread.sleep(forTimeInterval: 3)
            self.networkManager?.fetch(url: APIHandler.urlForGetting(.allAddressesOf(customer_id: self.dummyCustomerId)), type: Addresses.self) { addressesContainer in
                for address in (addressesContainer?.addresses) ?? [] {
                    if String(address.id) == addressID ?? "" {
                            print(address.id)
                        XCTAssertTrue(address.addressDefault, "Put not working properly")
                            expectation.fulfill()
                            group.leave()
                            break
                    }
                }
            }
            group.wait()
        }
        waitForExpectations(timeout: 30, handler: nil)
    }
    
    
    func testDeleteFromApi(){
        let expectation = self.expectation(description: "Network request expectation")
        networkManager?.deleteFromApi(url: APIHandler.urlForGetting(.priceRules(id: "1171014352961")))
            expectation.fulfill()
        waitForExpectations(timeout: 30) { error in
             XCTAssertNil(error, "Timeout waiting for API request")
        }
    }
    func testDeleteFromApiFail(){
        let expectation = self.expectation(description: "Network request expectation")
        networkManager?.deleteFromApi(url: APIHandler.urlForGetting(.priceRule))
        expectation.fulfill()
        waitForExpectations(timeout: 30) { error in
             XCTAssertNil(error, "Timeout waiting for API request")
        }
    }
    
    func testPostWithResponseSuccess() {
        let expectation = self.expectation(description: "Network request expectation")
        let apiUrl = APIHandler.urlForGetting(.allAddressesOf(customer_id: dummyCustomerId))
        let parameters = ["address":["name": "toni kross", "phone": "44521", "address1": "Munich", "city": "Munich", "country": "Germany"]]
        networkManager?.postWithResponse(url: apiUrl, type: CustomerAddressResponse.self, parameters: parameters, completion: { response in
//            XCTAssertNotNil(response, "Error")
//            expectation.fulfill()
        })
        Thread.sleep(forTimeInterval: 3)
        networkManager?.fetch(url: APIHandler.urlForGetting(.allAddressesOf(customer_id: dummyCustomerId)), type: Addresses.self) { addressesContainer in
            XCTAssert(addressesContainer?.addresses.last?.name == "toni kross", "Post function not working properly")
                    expectation.fulfill()
        }
        waitForExpectations(timeout: 30, handler: nil)
    }
    
    func testPutWithResponseFunction(){
        let expectation = self.expectation(description: "Network request expectation")
        var addressID: String?
        let queue = DispatchQueue(label: "Serially Do")
        queue.async {
            let group = DispatchGroup()
            
            group.enter()
            self.networkManager?.fetch(url: APIHandler.urlForGetting(.allAddressesOf(customer_id: self.dummyCustomerId)), type: Addresses.self) { addressesContainer in
                for address in (addressesContainer?.addresses) ?? [] {
                    if address.name == self.dummyName {
                        print("\(address.name) assigninig id")
                        addressID = String(address.id)
                        group.leave()
                        break
                    }
                }
            }
            group.wait()
            
            let apiUrl = APIHandler.urlForGetting(.makeDefaultAddress(customer_id: self.dummyCustomerId, address_id: addressID ?? ""))
            self.networkManager?.putWithResponse(url: apiUrl, type: CustomerAddressResponse.self, completion: { addressRespons in
                //
            })
            
            group.enter()
            Thread.sleep(forTimeInterval: 3)
            self.networkManager?.fetch(url: APIHandler.urlForGetting(.allAddressesOf(customer_id: self.dummyCustomerId)), type: Addresses.self) { addressesContainer in
                for address in (addressesContainer?.addresses) ?? [] {
                    if String(address.id) == addressID ?? "" {
                            print(address.id)
                        XCTAssertTrue(address.addressDefault, "Put not working properly")
                            expectation.fulfill()
                            group.leave()
                            break
                    }
                }
            }
            group.wait()
        }
        waitForExpectations(timeout: 30, handler: nil)
    }
    

}
