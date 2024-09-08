//
//  MeViewController.swift
//  HEIN
//
//  Created by Youssif Hany on 03/09/2024.
//

import UIKit

protocol AddressesProtocol {
    var addresses : [Address]? { get set }
    func addAddress(address: Address)
    func deleteAddress(address: Address)
    func updateAddress(address: Address)
}

class MeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddressesProtocol {
    
    @IBOutlet weak var meTable: UITableView!
    
    // MARK: - change to be dynamic
    var customerId : Int? = 8369844912424
    
    var viewModel : MeViewModel?
    
    var orders : [Order]? {
        didSet{
           meTable.reloadData()
        }
    }
    
    var addresses : [Address]? {
        didSet{
            meTable.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        meTable.delegate = self
        meTable.dataSource = self
        
        setMeViewModel()
        getOrdersAndAddresses()
    }
    
    func getOrdersAndAddresses() {
        viewModel?.getOrders()
        viewModel?.getAddresses()
    }
    
    func setMeViewModel() {
        viewModel = MeViewModel(customerId: customerId ?? 0)
        viewModel? .bindResultToViewController = {
            if self.viewModel?.orders?.count == 0 || self.viewModel?.orders == nil {
                self.orders = []
            } else {
                self.orders = self.viewModel?.orders
            }
            
            if self.viewModel?.addresses?.count == 0 || self.viewModel?.addresses == nil {
                self.addresses = []
            } else {
                self.addresses = self.viewModel?.addresses
            }
        }
    }
    
    func addAddress(address: Address) {
        addresses?.append(address)
        meTable.reloadData()
    }
    
    func deleteAddress(address: Address) {
        addresses?.removeAll(where: { $0.id == address.id })
        meTable.reloadData()
    }
    
    func updateAddress(address: Address) {
        addresses![(addresses?.firstIndex(where: {$0.id == address.id}))!] = address
        meTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = meTable.dequeueReusableCell(withIdentifier: "meCell", for: indexPath)
        
        switch indexPath.row{
        case 0:
            cell.textLabel?.text = "My Orders"
            cell.detailTextLabel?.text = "\(orders?.count.description ?? "●") orders"
        case 1:
            cell.textLabel?.text = "Shipping Addresses"
            cell.detailTextLabel?.text = "\(addresses?.count.description ?? "●") addresses"
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
            ordersVC.orders = self.orders
            navigationController?.pushViewController(ordersVC, animated: true)
        case 1:
            let addressesVC = storyboard?.instantiateViewController(identifier: "addresses") as! AddressesViewController
            addressesVC.addresses = self.addresses
            addressesVC.ref = self
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

