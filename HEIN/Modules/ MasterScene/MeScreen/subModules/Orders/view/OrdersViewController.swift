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
    
    var viewModel : OrdersViewModel?
    
    var orders : [Order]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "HEIN"
        
        ordersTable.delegate = self
        ordersTable.dataSource = self
        
        ordersTableIndicator.isHidden = true
        
        setOrdersViewModel()
        
        if orders?.count == 0 {
            emptyOrdersLable.isHidden = false
        } else if orders == nil {
            self.ordersTableIndicator.startAnimating()
            viewModel?.getOrders()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel?.getOrders()
    }
    
    func setOrdersViewModel() {
        viewModel = OrdersViewModel()
        viewModel?.bindResultToViewController = {
            if let orders = self.viewModel?.orders {
                self.orders = orders
            } else {
                self.emptyOrdersLable.text = "Couldn't find any orders"
                self.emptyOrdersLable.isHidden = false
            }
            self.ordersTableIndicator.stopAnimating()
            self.ordersTable.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ordersTable.dequeueReusableCell(withIdentifier: "ordersCell", for: indexPath) as! OrdersTableViewCell
        
        cell.orderNumberLabel.text = orders?[indexPath.row].id.description
        cell.orderDateLabel.text = String((orders?[indexPath.row].createdAt ?? "").prefix(10))
        
        var quantity = 0
        for item in (orders?[indexPath.row].lineItems)! {
            quantity += Int(item.quantity)
        }
        cell.orderQuantityLabel.text = "\(quantity)" //orders?[indexPath.row].lineItems.count.description
        
        cell.totalAmountLabel.text = ExchangeCurrency.exchangeCurrency(amount: orders?[indexPath.row].totalOutstanding)
        cell.currencyLabel.text = ExchangeCurrency.getCurrency()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }

}

