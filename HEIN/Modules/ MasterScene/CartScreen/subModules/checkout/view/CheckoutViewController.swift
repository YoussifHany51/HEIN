//
//  CheckoutViewController.swift
//  HEIN
//
//  Created by Marco on 2024-09-12.
//

import UIKit

class CheckoutViewController: UIViewController {

    @IBOutlet weak var processingOrderView: UIView!
    
    @IBOutlet weak var currencyLable: UILabel!
    
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
        
        self.subtotalAmount.text = ExchangeCurrency.exchangeCurrency(amount: draftOrder?.subtotalPrice)
        self.discountAmount.text = draftOrder?.appliedDiscount != nil ? ExchangeCurrency.exchangeCurrency(amount: draftOrder?.appliedDiscount?.value) : "" 
        self.taxFeeAmount.text = ExchangeCurrency.exchangeCurrency(amount: draftOrder?.totalTax)
        self.grandTotalAmount.text = ExchangeCurrency.exchangeCurrency(amount: draftOrder?.totalPrice)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel?.getAddresses()
        currencyLable.text = ExchangeCurrency.getCurrency()
    }
    
    func setCheckoutViewModel() {
        viewModel = CheckoutViewModel(draftOrder: draftOrder)
        viewModel?.bindResultToViewController = { [self] in
            if let defaultAddress = viewModel?.defaultAddress {
                addressTitle.text = defaultAddress.name
                addressStreet.text = defaultAddress.address1
                addressCity.text = defaultAddress.city
                addressCountry.text = defaultAddress.country
                addressPhone.text = defaultAddress.phone
                
                paymentButton.isEnabled = true
                loadingView.isHidden = true
                addAddressButton.isHidden = true
            } else {
                addressIndicator.stopAnimating()
                addAddressButton.isHidden = false
                paymentButton.isEnabled = false
            }
            if processingOrderView.isHidden == false {
                processingOrderView.isHidden = true
                let paymentVC = storyboard?.instantiateViewController(withIdentifier: "payment") as! PaymentViewController
                paymentVC.draftOrder = draftOrder
                navigationController?.pushViewController(paymentVC, animated: true)
            }
        }
        
        viewModel?.bindProcessingErrorToViewController = { [self] in
            showAlert()
            processingOrderView.isHidden = true
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Error...‼️", message: "Something went wrong please try again", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }

    @IBAction func goToPayment(_ sender: Any) {
        processingOrderView.isHidden = false
        viewModel?.updateDraftOrderAddress()
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
