//
//  PaymentViewController.swift
//  HEIN
//
//  Created by Marco on 2024-09-14.
//

import UIKit
import PassKit

class PaymentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PKPaymentAuthorizationViewControllerDelegate {

    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var paymentTable: UITableView!
    @IBOutlet weak var submitOrderButton: CustomButton!
    
    var paymentViewModel: PaymentViewModel?
    
    var draftOrder: DraftOrder?
    
    private var paymentRequest : PKPaymentRequest = PKPaymentRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "HEIN"
        
        paymentTable.delegate = self
        paymentTable.dataSource = self
        
        setViewModel()
        
        submitOrderButton.isEnabled = false
        
        paymentViewModel?.configurePaymentRequest(request: paymentRequest)
    }
    
    func setViewModel() {
        paymentViewModel = PaymentViewModel(draftOrder: draftOrder)
        paymentViewModel?.bindResultToViewController = {
            let orderConfirmedVC = self.storyboard?.instantiateViewController(withIdentifier: "orderConfirmed")
            guard let orderConfirmedVC = orderConfirmedVC else {return}
            self.navigationController?.present(orderConfirmedVC, animated: true, completion: {
                self.navigationController?.popToRootViewController(animated: false)
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ReachabilityManager.checkNetworkReachability { isReachable in
            if !isReachable {
                ReachabilityManager.showConnectionAlert(view: self)
            }
        }
    }

    @IBAction func submitOrder(_ sender: Any) {
        ReachabilityManager.checkNetworkReachability { isReachable in
            if !isReachable {
                ReachabilityManager.showConnectionAlert(view: self)
            }
        }
        
        if (paymentViewModel?.paymentMethods[0].isSelected)! {
            loadingView.isHidden = false
            paymentViewModel?.postOrder()
        } else {
            payWithApplePay()
        }
        
    }
    
    func payWithApplePay(){
        let amount = draftOrder?.totalPrice
        paymentRequest.paymentSummaryItems = [PKPaymentSummaryItem(label: "Cart Order", amount: NSDecimalNumber(string: ExchangeCurrency.exchangeCurrency(amount: amount) ))]
            
            let controller = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
            if controller != nil {
                controller!.delegate = self
                present(controller!, animated: true, completion: nil)
            }
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true)
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
        paymentViewModel?.postOrder()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        paymentViewModel?.paymentMethods.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = paymentTable.dequeueReusableCell(withIdentifier: "paymentCell", for: indexPath) as! PaymentTableViewCell
        
        cell.paymentMethodName.text = paymentViewModel?.paymentMethods[indexPath.row].name
        cell.paymentMethodImage.image = UIImage(named: (paymentViewModel?.paymentMethods[indexPath.row].image)!)
        cell.paymentMethodIsSelectedImage.image = (paymentViewModel?.paymentMethods[indexPath.row].isSelected)! ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circle")
        
        cell.selectionStyle = .none

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        paymentViewModel?.setSelectedPaymentMethodUI(selectedIndex: indexPath.row)
        paymentTable.reloadData()
        submitOrderButton.isEnabled = true
    }

}
