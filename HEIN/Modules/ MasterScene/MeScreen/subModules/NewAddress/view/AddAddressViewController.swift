//
//  AddAddressViewController.swift
//  HEIN
//
//  Created by Marco on 2024-09-07.
//

import UIKit
import CoreLocation

protocol AddressLocationProtocol {
    func updateAddressLocation(coordinates: String)
}

class AddAddressViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddressLocationProtocol {

    @IBOutlet weak var chooseOnMapLabel: UILabel!
    @IBOutlet weak var checkLocationLabel: UILabel!
    @IBOutlet weak var deleteAddressButton: UIButton!
    @IBOutlet weak var viewTitleLabel: UILabel!
    @IBOutlet weak var saveAddressButton: CustomButton!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var fieldsTable: UITableView!
    
    var viewModel : AddAddressViewModel?
    
    var ref : AddressesProtocol?
    
    var editingAddress: Address?
    
    var addressLocation: String? {
        didSet {
            self.checkLocationLabel.isHidden = false
            self.chooseOnMapLabel.alpha = 0.2
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "HEIN"
        
        fieldsTable.delegate = self
        fieldsTable.dataSource = self
        
        if editingAddress != nil {
            deleteAddressButton.isHidden = false
            deleteAddressButton.isEnabled = editingAddress!.addressDefault ? false : true
            
            if let location = editingAddress?.address2 {
                if location.contains("-") {addressLocation = location}
            }
        }
        
        viewTitleLabel.text = editingAddress != nil ? "Edit Shipping Address" : "Add Shipping Address"
        
        let textFeildCellNib = UINib(nibName: "TextFieldViewCell", bundle: nil)
        fieldsTable.register(textFeildCellNib, forCellReuseIdentifier: "textFieldCell")
        
        setAddAddressViewModel()
    }
    
    func updateAddressLocation(coordinates: String) {
        self.addressLocation = coordinates
        self.fieldsTable.reloadData()
    }
    
    @IBAction func chooseOnMap(_ sender: Any) {
        let mapVC = storyboard?.instantiateViewController(withIdentifier: "map") as! MapViewController
        if addressLocation != nil {
            mapVC.editingLocation = CLLocation(latitude: Double(addressLocation!.components(separatedBy: "-").first!) ?? 30.033333, longitude: Double(addressLocation!.components(separatedBy: "-").last!) ?? 31.233334)
        }
        mapVC.ref = self
        navigationController?.present(mapVC, animated: true)
    }
    
    func setAddAddressViewModel() {
        viewModel = AddAddressViewModel()
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
        for row in 1...5 {
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
                viewModel?.addNewAddress(street: getCellAtRow(2).textField.text!,
                                         city: getCellAtRow(3).textField.text!,
                                         country: getCellAtRow(4).textField.text!,
                                         phone: getCellAtRow(5).textField.text!,
                                         name: getCellAtRow(1).textField.text!, addressLocation: addressLocation)
            } else {
                viewModel?.UpdateAddress(addressID: editingAddress!.id, 
                                         street: getCellAtRow(2).textField.text!,
                                         city: getCellAtRow(3).textField.text!,
                                         country: getCellAtRow(4).textField.text!,
                                         phone: getCellAtRow(5).textField.text!,
                                         name: getCellAtRow(1).textField.text!, addressLocation: addressLocation)
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
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = fieldsTable.dequeueReusableCell(withIdentifier: "textFieldCell") as! TextFieldViewCell
        
        switch indexPath.row{
        case 0:
            let mapCell = fieldsTable.dequeueReusableCell(withIdentifier: "mapCell") as! MapTableViewCell
            mapCell.latitude = Double(addressLocation?.components(separatedBy: "-").first ?? "")
            mapCell.longitude = Double(addressLocation?.components(separatedBy: "-").last ?? "")
            mapCell.configureMapCell()
            return mapCell
        case 1:
            cell.labelName.text = "Address Name"
            cell.textField.text = editingAddress?.name ?? ""
        case 2:
            cell.labelName.text = "Street"
            cell.textField.text = editingAddress?.address1 ?? ""
        case 3:
            cell.labelName.text = "City"
            cell.textField.text = editingAddress?.city ?? ""
        case 4:
            cell.labelName.text = "Country"
            cell.textField.text = "Egypt"
            cell.textField.alpha = 0.5
            cell.textField.isEnabled = false
        case 5:
            cell.labelName.text = "Phone"
            cell.textField.text = editingAddress?.phone ?? ""
        default:
            cell.labelName.text = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            if addressLocation == nil {
                return 0
            }
            return 180
        }
        return 120
    }
    
    func getCellAtRow(_ row: Int) -> TextFieldViewCell {
        // Scroll to cell inorder to load it
        fieldsTable.scrollToRow(at: IndexPath(row: row, section: 0), at: .top, animated: false)
        
        return fieldsTable.cellForRow(at: IndexPath(row: row, section: 0)) as! TextFieldViewCell
    }

}

