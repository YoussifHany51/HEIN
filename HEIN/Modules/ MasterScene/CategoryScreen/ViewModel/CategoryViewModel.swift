//
//  CategoryViewModel.swift
//  HEIN
//
//  Created by Mahmoud  on 10/09/2024.
//

import Foundation


protocol CategoryProtocol {
    func loadData()
    func checkNetworkReachability(completion: @escaping (Bool) -> Void)
    func filterResult()
    var filteredResultArr : [Product]?{get set}
    var men :[Product]?{get set}
    var women :[Product]?{get set}
    var kid :[Product]?{get set}
    var AllProducct : Products?{get set}
    var bindProductToViewController : (()->()) {get set}
}

class CategoriesViewModel:CategoryProtocol{

    var networkHandler:NetworkManager?
    var bindProductToViewController : (()->()) = {}
    var men :[Product]?
    var women :[Product]?
    var kid :[Product]?
    let model = ReachabilityManager()
    var AllProducct : Products?{
         didSet{
             bindProductToViewController()
         }
     }
    var filteredResultArr : [Product]?
    
     init() {
         self.networkHandler = NetworkManager()
         men = [] 
         women = []
         kid = []
     }
    
     func loadData(){
         let apiUrl = APIHandler.urlForGetting(.products)
         networkHandler?.fetch(url: apiUrl, type: Products.self, complitionHandler: { data in
             self.AllProducct = data
             self.filterResult()
       
         })
     }
    
     func filterResult() {
    
        print("Starting filtering process...")
        for item in AllProducct?.products ?? [] {
            let components = item.tags.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            print("Components: \(components)")
            if components.contains("men") {
                print("Adding to men: \(item.title)")
                men?.append(item)
            } else if components.contains("women") {
                print("Adding to women: \(item.title)")
                women?.append(item)
            } else if components.contains("kid") {
                print("Adding to kid: \(item.title)")
                kid?.append(item)
            }
        }
    
    }

  func checkNetworkReachability(completion: @escaping (Bool) -> Void) {
      model.checkNetworkReachability { isReachable in
          completion(isReachable)
      }
  }

}



