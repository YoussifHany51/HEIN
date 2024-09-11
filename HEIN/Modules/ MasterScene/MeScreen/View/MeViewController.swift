//
//  MeViewController.swift
//  HEIN
//
//  Created by Youssif Hany on 03/09/2024.
//

import UIKit
import FirebaseAuth

class MeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var meTable: UITableView!
    
    // MARK: - change to be dynamic
    var customerId : Int? = 8369844912424
    
    var viewModel : MeViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        meTable.delegate = self
        meTable.dataSource = self
        
        if let user = Auth.auth().currentUser {
            userNameLabel.text = UserDefaults.standard.string(forKey: user.uid)
        } else {
            userNameLabel.text = .none
        }
        
        setMeViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getOrdersAndAddresses()
    }
    
    func getOrdersAndAddresses() {
        viewModel?.getOrders()
        viewModel?.getAddresses()
    }
    
    func setMeViewModel() {
        viewModel = MeViewModel(customerId: customerId ?? 0)
        viewModel? .bindResultToViewController = {
            self.meTable.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = meTable.dequeueReusableCell(withIdentifier: "meCell", for: indexPath)
        
        switch indexPath.row{
        case 0:
            cell.textLabel?.text = "My Orders"
            cell.detailTextLabel?.text = "\(viewModel?.orders?.count.description ?? "●") orders"
        case 1:
            cell.textLabel?.text = "Shipping Addresses"
            cell.detailTextLabel?.text = "\(viewModel?.addresses?.count.description ?? "●") addresses"
        case 2:
            cell.textLabel?.text = "Currency"
            cell.detailTextLabel?.text = "EGP"
        case 3:
            cell.textLabel?.text = "Sign Out"
            cell.detailTextLabel?.text = .none
        default:
            cell.textLabel?.text = "My Orders"
            cell.detailTextLabel?.text = "12 orders"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row{
        case 0:
            let ordersVC = storyboard?.instantiateViewController(identifier: "orders") as! OrdersViewController
            ordersVC.orders = self.viewModel?.orders
            navigationController?.pushViewController(ordersVC, animated: true)
        case 1:
            let addressesVC = storyboard?.instantiateViewController(identifier: "addresses") as! AddressesViewController
            addressesVC.addresses = self.viewModel?.addresses
            navigationController?.pushViewController(addressesVC, animated: true)
        case 2:
            let currencyVC = storyboard?.instantiateViewController(identifier: "currencies") as! CurrencyViewController
            navigationController?.pushViewController(currencyVC, animated: true)
        case 3:
            let alert = UIAlertController(title: "Sign Out..!", message: "You wont be able to make purchases from our poroduct catalog", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "sign out", style: .destructive, handler: { action in
                    // sign out action
            }))
            alert.addAction(UIAlertAction(title: "cancel", style: .default, handler: nil))
            self.present(alert, animated: true)
        default:
            return
        }
    }

}

