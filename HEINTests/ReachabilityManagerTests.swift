//
//  ReachabilityManagerTests.swift
//  E-CommerceAppTests
//
//  Created by Basma on 28/02/2024.
//

import XCTest
@testable import HEIN

final class ReachabilityManagerTests: XCTestCase {
    
    var reachabilityManager : ReachabilityManager!
    
    override func setUpWithError() throws {
        reachabilityManager = ReachabilityManager()
    }

    override func tearDownWithError() throws {
        reachabilityManager = nil
    }

   
    func testCheckNetworkReachabilityWhenReachable() {

        let expectation = expectation(description: "Network Reachable Expectation")
        reachabilityManager.checkNetworkReachability { isReachable in
           
            XCTAssertTrue(isReachable, "Network should be reachable")
          
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
}
