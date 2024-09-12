//
//  CheckoutViewController.swift
//  HEIN
//
//  Created by Marco on 2024-09-12.
//

import UIKit

class CheckoutViewController: UIViewController {

    @IBOutlet weak var addressPhone: UILabel!
    @IBOutlet weak var addressCountry: UILabel!
    @IBOutlet weak var addressCity: UILabel!
    @IBOutlet weak var addressStreet: UILabel!
    @IBOutlet weak var addressTitle: UILabel!
    
    
    @IBOutlet weak var grandTotalAmount: UILabel!
    @IBOutlet weak var taxFeeAmount: UILabel!
    @IBOutlet weak var shippingFeeAmount: UILabel!
    @IBOutlet weak var discountAmount: UILabel!
    @IBOutlet weak var subtotalAmount: UILabel!
    
    
    @IBOutlet weak var paymentButton: CustomButton!
    
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var addAddressButton: UIButton!
    @IBOutlet weak var addressIndicator: UIActivityIndicatorView!
    
    var viewModel: CheckoutViewModel?
    
    var draftOrder: DraftOrder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.loadingView.isHidden = false
        
        setCheckoutViewModel()
        
        self.subtotalAmount.text = draftOrder?.subtotalPrice
        self.discountAmount.text = draftOrder?.appliedDiscount?.value
        self.taxFeeAmount.text = draftOrder?.totalTax
        self.grandTotalAmount.text = draftOrder?.totalPrice
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel?.getAddresses()
    }
    
    func setCheckoutViewModel() {
        viewModel = CheckoutViewModel()
        viewModel?.bindResultToViewController = { [self] in
            if let defaultAddress = viewModel?.defaultAddress {
                addressTitle.text = defaultAddress.name
                addressStreet.text = defaultAddress.address1
                addressCity.text = defaultAddress.city
                addressCountry.text = defaultAddress.country
                addressPhone.text = defaultAddress.phone
                
                loadingView.isHidden = true
            } else {
                addressIndicator.stopAnimating()
                addAddressButton.isHidden = false
                paymentButton.isEnabled = false
            }
        }
    }

    @IBAction func goToPayment(_ sender: Any) {
        // Add selected address to the draft order
    }
    
    @IBAction func addNewAddress(_ sender: Any) {
        let storyboard = UIStoryboard(name: "MeScreen", bundle: nil)
                
        guard let addAddressesVC = storyboard.instantiateViewController(withIdentifier: "addAddress") as? AddAddressViewController else {
            return
        }
                
        navigationController?.pushViewController(addAddressesVC, animated: true)
    }
    
    @IBAction func changeAddress(_ sender: Any) {
        let storyboard = UIStoryboard(name: "MeScreen", bundle: nil)
                
        guard let addressesVC = storyboard.instantiateViewController(withIdentifier: "addresses") as? AddressesViewController else {
            return
        }
        
        addressesVC.addresses = viewModel?.addresses
                
        navigationController?.pushViewController(addressesVC, animated: true)
    }
}
