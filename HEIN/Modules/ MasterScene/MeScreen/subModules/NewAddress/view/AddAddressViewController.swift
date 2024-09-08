//
//  AddAddressViewController.swift
//  HEIN
//
//  Created by Marco on 2024-09-07.
//

import UIKit

class AddAddressViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var deleteAddressButton: UIButton!
    @IBOutlet weak var viewTitleLabel: UILabel!
    @IBOutlet weak var saveAddressButton: CustomButton!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var fieldsTable: UITableView!
    
    // MARK: - change to be dynamic
    var customerId : Int? = 8369844912424
    
    var viewModel : AddAddressViewModel?
    
    var ref : AddressesProtocol?
    
    var address: Address?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        fieldsTable.delegate = self
        fieldsTable.dataSource = self
        
        if address != nil {
            deleteAddressButton.isHidden = false
            deleteAddressButton.isEnabled = address!.addressDefault ? false : true
        }
        
        viewTitleLabel.text = address != nil ? "Edit Shipping Address" : "Add Shipping Address"
        
        let textFeildCellNib = UINib(nibName: "TextFieldViewCell", bundle: nil)
        fieldsTable.register(textFeildCellNib, forCellReuseIdentifier: "textFieldCell")
        
        setAddAddressViewModel()
    }
    
    func setAddAddressViewModel() {
        viewModel = AddAddressViewModel(customerId: customerId ?? 0)
        viewModel?.bindResultToViewController = { operation in
            switch operation {
            case .addNew:
                guard let newAddress = self.viewModel?.newAddress else {
                    self.saveAddressButton.isEnabled = true
                    self.loadingView.isHidden = true
                    let alert = UIAlertController(title: "Address not saved ‼️", message: "Something went wrong please try again", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    return
                }
                self.ref?.addAddress(address: newAddress)
                self.navigationController?.popViewController(animated: true)
            case .delete:
                self.ref?.deleteAddress(address: self.address!)
                self.navigationController?.popViewController(animated: true)
            case .update:
                let updatedAddress = Address(id: self.address!.id, customerID: self.customerId!, address1: self.getCellAtRow(1).textField.text!, city: self.getCellAtRow(2).textField.text!, phone: self.getCellAtRow(4).textField.text!, name: self.getCellAtRow(0).textField.text!, country: self.getCellAtRow(3).textField.text!, addressDefault: self.address!.addressDefault)
                self.ref?.updateAddress(address: updatedAddress)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func saveAddreess(_ sender: Any) {
        var emptyFields : Int = 0
        for row in 0...4 {
            if getCellAtRow(row).textField.text == "" {
                getCellAtRow(row).requiredLabel.isHidden = false
                emptyFields += 1
            } else {
                getCellAtRow(row).requiredLabel.isHidden = true
            }
        }
        
        if emptyFields == 0 {
            self.saveAddressButton.isEnabled = false
            self.loadingView.isHidden = false
            
            if address == nil {
                viewModel?.addNewAddress(street: getCellAtRow(1).textField.text!, city: getCellAtRow(2).textField.text!, country: getCellAtRow(3).textField.text!, phone: getCellAtRow(4).textField.text!, name: getCellAtRow(0).textField.text!)
            } else {
                viewModel?.UpdateAddress(addressID: address!.id, street: getCellAtRow(1).textField.text!, city: getCellAtRow(2).textField.text!, country: getCellAtRow(3).textField.text!, phone: getCellAtRow(4).textField.text!, name: getCellAtRow(0).textField.text!)
            }
        }
    }
    
    @IBAction func deleteAddressButtonAction(_ sender: Any) {
        let alert = UIAlertController(title: "Delete.!", message: "Selected address would be deleted", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "delete", style: .destructive, handler: { action in
            self.saveAddressButton.isEnabled = false
            self.loadingView.isHidden = false
            self.viewModel?.deleteAddress(addressID: (self.address?.id)!)
        }))
        alert.addAction(UIAlertAction(title: "cancel", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = fieldsTable.dequeueReusableCell(withIdentifier: "textFieldCell", for: indexPath) as! TextFieldViewCell
        
        switch indexPath.row{
        case 0:
            cell.labelName.text = "Address Name"
            cell.textField.text = address?.name ?? ""
        case 1:
            cell.labelName.text = "Street"
            cell.textField.text = address?.address1 ?? ""
        case 2:
            cell.labelName.text = "City"
            cell.textField.text = address?.city ?? ""
        case 3:
            cell.labelName.text = "Country"
            cell.textField.text = "Egypt"
            cell.textField.alpha = 0.5
            cell.textField.isEnabled = false
        case 4:
            cell.labelName.text = "Phone"
            cell.textField.text = address?.phone ?? ""
        default:
            cell.labelName.text = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func getCellAtRow(_ row: Int) -> TextFieldViewCell {
        return fieldsTable.cellForRow(at: IndexPath(row: row, section: 0)) as! TextFieldViewCell
    }

}

