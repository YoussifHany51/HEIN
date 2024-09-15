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
    
    var editingAddress: Address?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        fieldsTable.delegate = self
        fieldsTable.dataSource = self
        
        if editingAddress != nil {
            deleteAddressButton.isHidden = false
            deleteAddressButton.isEnabled = editingAddress!.addressDefault ? false : true
        }
        
        viewTitleLabel.text = editingAddress != nil ? "Edit Shipping Address" : "Add Shipping Address"
        
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
                    self.showAlert()
                    return
                }
                self.ref?.addAddress(address: newAddress)
                self.navigationController?.popViewController(animated: true)
                
            case .delete:
                self.ref?.deleteAddress(address: self.editingAddress!)
                self.navigationController?.popViewController(animated: true)
                
            case .update:
                guard let updatedAddress = self.viewModel?.updatedAddress else {
                    self.saveAddressButton.isEnabled = true
                    self.loadingView.isHidden = true
                    self.showAlert()
                    return
                }
                self.ref?.updateAddress(address: updatedAddress)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Address not saved ‼️", message: "Something went wrong please try again", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func saveAddreess(_ sender: Any) {
        var emptyFields : [Int] = []
        for row in 0...4 {
            if getCellAtRow(row).textField.text == "" {
                getCellAtRow(row).requiredLabel.isHidden = false
                emptyFields.append(row)
            } else {
                getCellAtRow(row).requiredLabel.isHidden = true
            }
        }
        
        if emptyFields.count == 0 {
            self.saveAddressButton.isEnabled = false
            self.loadingView.isHidden = false
            
            if editingAddress == nil {
                viewModel?.addNewAddress(street: getCellAtRow(1).textField.text!, 
                                         city: getCellAtRow(2).textField.text!,
                                         country: getCellAtRow(3).textField.text!,
                                         phone: getCellAtRow(4).textField.text!,
                                         name: getCellAtRow(0).textField.text!)
            } else {
                viewModel?.UpdateAddress(addressID: editingAddress!.id, 
                                         street: getCellAtRow(1).textField.text!,
                                         city: getCellAtRow(2).textField.text!,
                                         country: getCellAtRow(3).textField.text!,
                                         phone: getCellAtRow(4).textField.text!,
                                         name: getCellAtRow(0).textField.text!)
            }
        } else {
            fieldsTable.scrollToRow(at: IndexPath(row: emptyFields.first!, section: 0), at: .top, animated: false)
        }
    }
    
    @IBAction func deleteAddressButtonAction(_ sender: Any) {
        let alert = UIAlertController(title: "Delete.!", message: "Selected address would be deleted", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "delete", style: .destructive, handler: { action in
            self.saveAddressButton.isEnabled = false
            self.loadingView.isHidden = false
            self.viewModel?.deleteAddress(addressID: (self.editingAddress?.id)!)
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
            cell.textField.text = editingAddress?.name ?? ""
        case 1:
            cell.labelName.text = "Street"
            cell.textField.text = editingAddress?.address1 ?? ""
        case 2:
            cell.labelName.text = "City"
            cell.textField.text = editingAddress?.city ?? ""
        case 3:
            cell.labelName.text = "Country"
            cell.textField.text = "Egypt"
            cell.textField.alpha = 0.5
            cell.textField.isEnabled = false
        case 4:
            cell.labelName.text = "Phone"
            cell.textField.text = editingAddress?.phone ?? ""
        default:
            cell.labelName.text = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func getCellAtRow(_ row: Int) -> TextFieldViewCell {
        // Scroll to cell inorder to load it
        fieldsTable.scrollToRow(at: IndexPath(row: row, section: 0), at: .top, animated: false)
        
        return fieldsTable.cellForRow(at: IndexPath(row: row, section: 0)) as! TextFieldViewCell
    }

}

