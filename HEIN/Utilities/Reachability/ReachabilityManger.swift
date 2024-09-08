//
//  ReachabilityManger.swift
//  HEIN
//
//  Created by Mahmoud  on 04/09/2024.
//

import Foundation
import Alamofire

class ReachabilityManager {
    func checkNetworkReachability(completion: @escaping (Bool) -> Void) {
        let reachabilityManager = NetworkReachabilityManager()
        completion(reachabilityManager?.isReachable ?? false)
    }
}
