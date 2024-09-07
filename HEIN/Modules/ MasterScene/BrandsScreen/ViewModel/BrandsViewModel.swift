//
//  BrandsViewModel.swift
//  HEIN
//
//  Created by Mahmoud  on 06/09/2024.
//

import Foundation

protocol BrandsProtocol {
    func loadData()
    func getBrands(vendor : String)
    func sortByPrice()
    func checkNetworkReachability(completion: @escaping (Bool) -> Void)
    func searchSorted(text:String)
    func searchBrands(text:String)
    var bindBrandsToViewController : (()->()){get set}
    var brandProducts :[Product]?{get}
    var sortedProducts : [Product]?{get}
}


class BrandsViewMode:BrandsProtocol{
    var networkHandler:NetworkManager?
    var bindBrandsToViewController : (()->()) = {}
    var _brandProducts :[Product]?
    let model = ReachabilityManager()
    var _sortedProducts : [Product]?
    var result : Products?{
         didSet{
             bindBrandsToViewController ()
         }
     }
    
     init() {
         self.networkHandler = NetworkManager()
     }
    
      var brandProducts :[Product]?{return _brandProducts}
      var sortedProducts : [Product]?{return _sortedProducts}
    
     func loadData(){
         let apiUrl = APIHandler.urlForGetting(.products)
         networkHandler?.fetch(url: apiUrl, type: Products.self, complitionHandler: { data in
             self.result = data
    
         })
     }
    
    func getBrands(vendor : String){
       
         self._brandProducts = self.result?.products.filter{
             $0.vendor == vendor
         } ?? []
     }
    
    func sortByPrice() {
        _sortedProducts = _brandProducts?.sorted {Double($0.variants.first?.price ?? "0.0") ?? 0.0  < Double($1.variants.first?.price ?? "0.0")  ?? 0.0 }
        }
    func searchSorted(text:String){
        _sortedProducts = _sortedProducts?.filter{$0.title.lowercased().contains(text.lowercased())}
    }
    func searchBrands(text:String){
     _brandProducts = _brandProducts?.filter{$0.title.lowercased().contains(text.lowercased())}
        
    }
    
    func checkNetworkReachability(completion: @escaping (Bool) -> Void) {
        model.checkNetworkReachability { isReachable in
            completion(isReachable)
        }
    }
}


