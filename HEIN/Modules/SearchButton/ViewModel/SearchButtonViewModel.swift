//
//  SearchButtonViewModel.swift
//  HEIN
//
//  Created by Youssif Hany on 08/09/2024.
//

import Foundation
class SearchButtonViewModel{
    
    var networkHandler:NetworkManager? = NetworkManager()
    let reachabilityManager = ReachabilityManager()
    var bindProductsToViewController : (()->()) = {}
    var result : Products?{
         didSet{
             bindProductsToViewController ()
         }
     }
    
    func loadData(){
        let apiUrl = APIHandler.urlForGetting(.products)
        networkHandler?.fetch(url: apiUrl, type: Products.self, complitionHandler: { data in
            self.result = data
   
        })
    }
}
