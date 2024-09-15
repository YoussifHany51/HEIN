//
//  OrderConfirmedViewController.swift
//  HEIN
//
//  Created by Marco on 2024-09-14.
//

import UIKit

class OrderConfirmedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.isHidden = true
    }
    

    @IBAction func continueShopping(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
