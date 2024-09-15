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
    var brandProducts :[Product]?{get set}
    var sortedProducts : [Product]?{get set}
}


class BrandsViewMode:BrandsProtocol{
    var networkHandler:NetworkManager?
    var bindBrandsToViewController : (()->()) = {}
    var brandProducts :[Product]?
    let model = ReachabilityManager()
    var sortedProducts : [Product]?
    var result : Products?{
         didSet{
             bindBrandsToViewController ()
         }
     }
    
     init() {
         self.networkHandler = NetworkManager()
     }
    

     func loadData(){
         let apiUrl = APIHandler.urlForGetting(.products)
         networkHandler?.fetch(url: apiUrl, type: Products.self, complitionHandler: { data in
             self.result = data
    
         })
     }
    
    func getBrands(vendor : String){
       
         self.brandProducts = self.result?.products.filter{
             $0.vendor == vendor
         } ?? []
     }
    
    func sortByPrice() {
        sortedProducts = brandProducts?.sorted {Double($0.variants.first?.price ?? "0.0") ?? 0.0  < Double($1.variants.first?.price ?? "0.0")  ?? 0.0 }
        }
    func searchSorted(text:String){
        sortedProducts = sortedProducts?.filter{$0.title.lowercased().contains(text.lowercased())}
    }
    func searchBrands(text:String){
     brandProducts = brandProducts?.filter{$0.title.lowercased().contains(text.lowercased())}
        
    }
    
    func checkNetworkReachability(completion: @escaping (Bool) -> Void) {
        model.checkNetworkReachability { isReachable in
            completion(isReachable)
        }
    }
}


