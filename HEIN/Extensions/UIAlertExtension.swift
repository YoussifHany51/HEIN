//
//  UIAlertExtension.swift
//  HEIN
//
//  Created by Mahmoud  on 12/09/2024.
//

import Foundation
import UIKit


extension UIAlertController{
    
    func showAlert(self:UIViewController){
        let alertController = UIAlertController(title: "No Internet Connection", message: "Check your network and try again", preferredStyle: .alert)
        
        let doneAction = UIAlertAction(title: "Retry", style: .cancel) { _ in
            self.viewWillAppear(true)
        }
        
        alertController.addAction(doneAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

