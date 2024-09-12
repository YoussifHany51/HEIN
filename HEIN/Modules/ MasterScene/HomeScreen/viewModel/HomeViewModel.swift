//
//  HomeViewModel.swift
//  HEIN
//
//  Created by Mahmoud  on 04/09/2024.
//

import Foundation

protocol HomeProtocol {
    func loadBrandCollectionData()
    func loadAdsCollectionData()
    func checkNetworkReachability(completion: @escaping (Bool) -> Void)
    var bindBrandsToViewController : (()->()) { get set }
    var bindAdsToViewController : (()->()) {get set}
    var ads: PriceRules? { get }
    var brands: [SmartCollection]? { get }
}


class HomeViewModel:HomeProtocol{
    
    var networkHandler:NetworkManager?
    var bindBrandsToViewController : (()->()) = {}
    var bindAdsToViewController : (()->()) = {}
    var _ads :PriceRules?
    var _brands : [SmartCollection]?
    let reachabilityHandler = ReachabilityManager()
    
    init() {
        self.networkHandler = NetworkManager()
    }
   
    var ads: PriceRules? {
           return _ads
       }
       
    var brands: [SmartCollection]? {
           return _brands
       }
    
    func loadBrandCollectionData(){
        let apiUrl = APIHandler.urlForGetting(.SmartCollections)
        networkHandler?.fetch(url: apiUrl, type: Collections.self, complitionHandler: { data in
            self._brands = data?.smartCollections
            print(SmartCollection.self)
            self.bindBrandsToViewController()
        })
    }
    
    func loadAdsCollectionData(){
        let apiUrl = APIHandler.urlForGetting(.priceRule)
        networkHandler?.fetch(url: apiUrl, type: PriceRules.self, complitionHandler: { data in
            self._ads = data
            self.bindAdsToViewController()
        })
    }

    func checkNetworkReachability(completion: @escaping (Bool) -> Void) {
        reachabilityHandler.checkNetworkReachability { isReachable in
            completion(isReachable)
        }
    }
  
}
