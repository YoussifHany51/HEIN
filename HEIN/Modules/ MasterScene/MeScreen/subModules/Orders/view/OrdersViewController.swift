//
//  OrdersViewController.swift
//  HEIN
//
//  Created by Marco on 2024-09-07.
//

import UIKit

class OrdersViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var ordersTableIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emptyOrdersLable: UILabel!
    @IBOutlet weak var ordersTable: UITableView!
    
    // MARK: - change to be dynamic
    var customerId : Int? = 8369844912424
    
    var viewModel : OrdersViewModel?
    
    var orders : [Order]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        ordersTable.delegate = self
        ordersTable.dataSource = self
        
        ordersTableIndicator.isHidden = true
        
        if orders?.count == 0 {
            emptyOrdersLable.isHidden = false
        } else if orders == nil {
            emptyOrdersLable.text = "Couldn't find any orders"
            emptyOrdersLable.isHidden = false
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ordersTable.dequeueReusableCell(withIdentifier: "ordersCell", for: indexPath) as! OrdersTableViewCell
        
        cell.orderNumberLabel.text = orders?[indexPath.row].id.description
        cell.orderDateLabel.text = String((orders?[indexPath.row].createdAt ?? "").prefix(10))
        cell.orderQuantityLabel.text = orders?[indexPath.row].lineItems.count.description
        cell.totalAmountLabel.text = orders?[indexPath.row].subtotalPrice
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }

}

