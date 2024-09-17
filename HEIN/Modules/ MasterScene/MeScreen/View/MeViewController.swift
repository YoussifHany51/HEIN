//
//  MeViewController.swift
//  HEIN
//
//  Created by Youssif Hany on 03/09/2024.
//

import UIKit
import FirebaseAuth

class MeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var meTable: UITableView!
    
    var viewModel : MeViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print(UserDefaults.standard.string(forKey: "User_id"))
        print(UserDefaults.standard.string(forKey: "User_name"))
        print(UserDefaults.standard.string(forKey: "DraftOrder_Id"))
        
        guard (UserDefaults.standard.string(forKey: "User_id") != nil) else {
            let guestMeVC = storyboard?.instantiateViewController(withIdentifier: "guestMe") as! GuestMeViewController
            navigationController?.pushViewController(guestMeVC, animated: true)
            return
        }
        
        meTable.delegate = self
        meTable.dataSource = self
        
        self.title = "HEIN"
        self.navigationController?.navigationBar.tintColor = UIColor(.red)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "arrowshape.turn.up.backward")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "arrowshape.turn.up.backward")
        
        if Auth.auth().currentUser != nil {
            userNameLabel.text = UserDefaults.standard.string(forKey: "User_name")
            userEmailLabel.text = Auth.auth().currentUser?.email
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
        viewModel = MeViewModel()
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
            cell.detailTextLabel?.text = UserDefaults.standard.string(forKey: "currencyTitle") ?? "USD"
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
            print("\(navigationController != nil)")
            navigationController?.pushViewController(addressesVC, animated: true)
        case 2:
            let currencyVC = storyboard?.instantiateViewController(identifier: "currencies") as! CurrencyViewController
            navigationController?.pushViewController(currencyVC, animated: true)
        case 3:
            let alert = UIAlertController(title: "Sign Out..!", message: "You wont be able to make purchases from our poroduct catalog", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "sign out", style: .destructive, handler: { action in
                    // sign out action
                do{
                    try Auth.auth().signOut()
                    let domain = Bundle.main.bundleIdentifier!
                    UserDefaults.standard.removePersistentDomain(forName: domain)
                    UserDefaults.standard.synchronize()
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let master = storyBoard.instantiateViewController(identifier: "LoginViewController")
                    self.present(master, animated: true)

                }catch let error{
                    print(error.localizedDescription)
                }
            }))
            alert.addAction(UIAlertAction(title: "cancel", style: .default, handler: nil))
            self.present(alert, animated: true)
        default:
            return
        }
    }

}

