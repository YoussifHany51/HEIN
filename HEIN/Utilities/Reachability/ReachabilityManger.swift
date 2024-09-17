//
//  ReachabilityManger.swift
//  HEIN
//
//  Created by Mahmoud  on 04/09/2024.
//

import Foundation
import Alamofire
import UIKit

class ReachabilityManager {
    func checkNetworkReachability(completion: @escaping (Bool) -> Void) {
        let reachabilityManager = NetworkReachabilityManager()
        completion(reachabilityManager?.isReachable ?? false)
    }
    
    static func checkNetworkReachability(completion: @escaping (Bool) -> Void) {
        let reachabilityManager = NetworkReachabilityManager()
        completion(reachabilityManager?.isReachable ?? false)
    }
    
    static func showConnectionAlert(view: UIViewController){
        let alertController = UIAlertController(title: "No Internet Connection", message: "Check your network and try again", preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "Retry", style: .cancel) { _ in
            self.checkNetworkReachability { isReachable in
                if isReachable {
                    return
                } else {
                    self.showConnectionAlert(view: view)
                }
            }
        }
        alertController.addAction(doneAction)
        view.present(alertController, animated: true, completion: nil)
    }
}
