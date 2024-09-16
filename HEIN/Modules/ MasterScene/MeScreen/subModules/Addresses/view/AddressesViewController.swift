//
//  AddressesViewController.swift
//  HEIN
//
//  Created by Marco on 2024-09-07.
//

import UIKit

protocol AddressesProtocol {
    func addAddress(address: Address)
    func deleteAddress(address: Address)
    func updateAddress(address: Address)
}

class AddressesViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, AddressesProtocol{

    @IBOutlet weak var addressesTableIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emptyAddressesLabel: UILabel!
    @IBOutlet weak var addressesTable: UITableView!
    
    var viewModel : AddressesViewModel?
    
    var addresses : [Address]?{
        didSet {
            defaultAddressIndex = addresses?.firstIndex(where: {$0.addressDefault == true})
        }
    }
    var defaultAddressIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        addressesTable.delegate = self
        addressesTable.dataSource = self
        
        setAddressesViewModel()
        
        if addresses == nil {
            addressesTableIndicator.startAnimating()
            viewModel?.getAddresses()
        } else if addresses?.count == 0 {
            emptyAddressesLabel.isHidden = false
        }
    }
    
    func setAddressesViewModel() {
        viewModel = AddressesViewModel()
        
        viewModel?.bindAddressesToViewController = {
            if let addresses = self.viewModel?.addresses {
                self.addresses = addresses
            } else {
                self.emptyAddressesLabel.text = "Couldn't find any addresses"
                self.emptyAddressesLabel.isHidden = false
            }
            self.addressesTableIndicator.stopAnimating()
            self.addressesTable.reloadData()
        }
        
        viewModel?.bindDefaultAddressToViewController = { [self] address in
            if let defaultIndex = defaultAddressIndex {
                if (addresses?[defaultIndex]) != nil {
                    self.addresses?[defaultIndex].addressDefault  = false
            }
        }
            
            let indexOfNewDefault = self.addresses!.firstIndex(where: {$0.id == address.id})!
            self.addresses?[indexOfNewDefault].addressDefault = true
            self.addressesTable.reloadData()
        }
    }
    
    func addAddress(address: Address) {
        addresses?.append(address)
        addressesTable.reloadData()
    }
    
    func deleteAddress(address: Address) {
        addresses?.removeAll(where: { $0.id == address.id })
        addressesTable.reloadData()
    }
    
    func updateAddress(address: Address) {
        addresses![(addresses?.firstIndex(where: {$0.id == address.id}))!] = address
        addressesTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = addressesTable.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath) as! AddressesTableViewCell
        
        cell.addressName.text = addresses?[indexPath.row].name
        cell.addressStreet.text = addresses?[indexPath.row].address1
        cell.addressCity.text = addresses?[indexPath.row].city
        cell.addressCountry.text =  addresses?[indexPath.row].country
        cell.addressPhone.text = addresses?[indexPath.row].phone
        cell.isDefault.isOn = addresses?[indexPath.row].addressDefault ?? false
        
        cell.changeDefaultAddress = {
            self.viewModel?.SetDefaultAddress(address: (self.addresses?[indexPath.row])!)
        }
        
        cell.editAddress = {
            let addAddressVC = self.storyboard?.instantiateViewController(withIdentifier: "addAddress") as! AddAddressViewController
            
            addAddressVC.editingAddress = self.addresses?[indexPath.row]
            addAddressVC.ref = self
            
            self.navigationController?.pushViewController(addAddressVC, animated: true)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 248
    }
    
    @IBAction func addNewAddressButtonAction(_ sender: Any) {
        let addAddressVC = storyboard?.instantiateViewController(withIdentifier: "addAddress") as! AddAddressViewController
        
        addAddressVC.ref = self
        
        navigationController?.pushViewController(addAddressVC, animated: true)
    }
    
}
