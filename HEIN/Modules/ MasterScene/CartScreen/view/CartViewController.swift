//
//  CartViewController.swift
//  HEIN
//
//  Created by Mahmoud  on 05/09/2024.
//

import UIKit
import Kingfisher

protocol CartProtocol {
    func updateCartTable(draftOrder: DraftOrder?)
}

class CartViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, CartProtocol {
    
    @IBOutlet weak var cartCountLabel: UILabel!
    @IBOutlet weak var promoCodeTextLabel: UILabel!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var discountAmount: UILabel!
    @IBOutlet weak var emptyCartLabel: UILabel!
    @IBOutlet weak var cartTable: UITableView!
    @IBOutlet weak var promoCodeButton: UIButton!
    @IBOutlet weak var promoCodeField: UITextField!
    @IBOutlet weak var currency: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var checkOutButton: UIButton!
    
    var viewModel : CartScreenViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        guard (UserDefaults.standard.string(forKey: "DraftOrder_Id") != nil) else {
            let guestCartVC = storyboard?.instantiateViewController(withIdentifier: "guestCart") as! GuestCartViewController
            navigationController?.pushViewController(guestCartVC, animated: true)
            return
        }
        
        setNavigationBar()
        
        cartTable.delegate = self
        cartTable.dataSource = self
        
        let cartCellNib = UINib(nibName: "CartTableViewCell", bundle: nil)
        cartTable.register(cartCellNib, forCellReuseIdentifier: "cartCell")
        
        self.loadingView.isHidden = false
        
        setViewModel()
        
//        for i in 0...2 {
//            UserDefaults.standard.removeObject(forKey: "coupon\(i)")
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.loadingView.isHidden = false
        viewModel?.getDraftOrder()
        currency.text = ExchangeCurrency.getCurrency()
        ReachabilityManager.checkNetworkReachability { isReachable in
            if !isReachable {
                ReachabilityManager.showConnectionAlert(view: self)
            }
        }
    }
    
    func setNavigationBar() {
        self.navigationItem.title = "HEIN"
        self.navigationController?.navigationBar.tintColor = UIColor(.red)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "arrowshape.turn.up.backward")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "arrowshape.turn.up.backward")
    }
    
    func setViewModel() {
        viewModel = CartScreenViewModel()
        viewModel?.bindResultToViewController = {
            self.loadingView.isHidden = true
            
            if self.viewModel?.lineItems?.count == 0 || self.viewModel?.lineItems == nil {
                self.emptyCartLabel.isHidden = false
                self.totalAmount.text = "0"
                self.checkOutButton.isEnabled = false
                self.promoCodeButton.isEnabled = false
                self.cartCountLabel.isHidden = true
                if self.viewModel?.lineItems == nil {
                    self.showAlert()
                }
                self.setDiscountUI()
            } else {
                self.totalAmount.text = ExchangeCurrency.exchangeCurrency(amount: self.viewModel?.draftOrder?.subtotalPrice)
                
                var quantity = 0
                for item in (self.viewModel?.lineItems)! {
                    quantity += Int(item.quantity)
                }
                self.cartCountLabel.text = "(\(quantity))"
                self.cartCountLabel.isHidden = false
                
                self.emptyCartLabel.isHidden = true
                self.checkOutButton.isEnabled = true
                self.promoCodeButton.isEnabled = true
                self.setDiscountUI()
            }
            self.cartTable.reloadData()
        }
    }
    
    func updateCartTable(draftOrder: DraftOrder?) {
        viewModel?.draftOrder = draftOrder
        
        if draftOrder?.appliedDiscount != nil {
            promoCodeTextLabel.text = "Coupon Applied"
            promoCodeTextLabel.textColor = UIColor.systemGreen
        } else {
            promoCodeTextLabel.text = "Invalid Coupon"
            promoCodeTextLabel.textColor = UIColor.systemRed
        }
        promoCodeTextLabel.isHidden = false
        
        cartTable.reloadData()
    }
    
    func setDiscountUI() {
        if let discount = self.viewModel?.draftOrder?.appliedDiscount {
            promoCodeButton.imageView?.image = UIImage(systemName: "xmark")
            
            self.discountAmount.text = "\(ExchangeCurrency.exchangeCurrency(amount: discount.value)) \(discount.valueType == "fixed_amount" ? "\(ExchangeCurrency.getCurrency())" : "%")"
            self.discountAmount.isHidden = false
            
            self.promoCodeTextLabel.text = "Coupon Applied"
            self.promoCodeTextLabel.textColor = UIColor.systemGreen
            self.promoCodeTextLabel.isHidden = false
        } else {
            self.discountAmount.isHidden = true
            self.promoCodeTextLabel.isHidden = true
        }
        
        self.promoCodeButton.layer.backgroundColor = UIColor.lightGray.cgColor
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Error", message: "Something went wrong please try again", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func promoCodeAction(_ sender: Any) {
        ReachabilityManager.checkNetworkReachability { isReachable in
            if !isReachable {
                ReachabilityManager.showConnectionAlert(view: self)
            }
        }
        
        if viewModel?.draftOrder?.appliedDiscount == nil {
            let couponVc = self.storyboard?.instantiateViewController(withIdentifier: "coupons") as! CouponsViewController
            couponVc.draftOrder = self.viewModel?.draftOrder
            couponVc.ref = self
            if let presentationController = couponVc.presentationController as? UISheetPresentationController {
                presentationController.detents = [.medium()]
            }
            self.present(couponVc, animated: true)
        } else {
            self.loadingView.isHidden = false
            viewModel?.removeDraftOrderAppliedDiscount()
        }
    }
    
    @IBAction func checkout(_ sender: Any) {
        ReachabilityManager.checkNetworkReachability { isReachable in
            if !isReachable {
                ReachabilityManager.showConnectionAlert(view: self)
            }
        }
        
        let checkoutVC = storyboard?.instantiateViewController(withIdentifier: "checkout") as! CheckoutViewController
        
        checkoutVC.draftOrder = viewModel?.draftOrder
        
        navigationController?.pushViewController(checkoutVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.lineItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartTable.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as! CartTableViewCell
        
        cell.productName.text = viewModel?.lineItems?[indexPath.row].name
        cell.productQuantity.text = viewModel?.lineItems?[indexPath.row].quantity.description
        
        let itemPrice = Float(viewModel?.lineItems?[indexPath.row].price ?? "0")! * Float(UserDefaults.standard.string(forKey: "factor") ?? "1")!
        let itemQuantity = Float((viewModel?.lineItems?[indexPath.row].quantity)!)
        
        cell.productTotalAmount.text = String(format:"%.2f",itemQuantity * itemPrice)
        cell.currencyTitle.text = UserDefaults.standard.string(forKey: "currencyTitle") ?? "USD"
        
        cell.productImage.kf.setImage(with: URL(string: (viewModel?.lineItems?[indexPath.row].properties[0].value)!), placeholder: UIImage(systemName: "clear") )
        
        cell.productOption1.text = viewModel?.lineItems?[indexPath.row].properties[1].name
        cell.productOption1_Value.text = viewModel?.lineItems?[indexPath.row].properties[1].value
        
        cell.productOption2.text = viewModel?.lineItems?[indexPath.row].properties[2].name
        cell.productOption2_Value.text = viewModel?.lineItems?[indexPath.row].properties[2].value

        cell.addOneProductButton.isEnabled = viewModel?.lineItems?[indexPath.row].quantity ?? 0 < viewModel?.variantsStock[indexPath.row].stock ?? 0
        
        cell.changeProductQuantity = { tag in
            self.loadingView.isHidden = false
            switch tag {
            // remove one item
            case 0:
                if self.viewModel?.lineItems?[indexPath.row].quantity == 1{
                    let alert = UIAlertController(title: "Remove item..!", message: "Item will be removed from cart", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "remove", style: .destructive, handler: { action in
                        self.viewModel?.lineItems?.remove(at: indexPath.row)
                        self.viewModel?.updateDraftOrderLineItems(lineItems: (self.viewModel?.lineItems)!)
                        self.cartTable.reloadData()
                    }))
                    alert.addAction(UIAlertAction(title: "cancel", style: .default, handler: { action in
                        return
                    }))
                    self.present(alert, animated: true)
                } else {
                    //self.viewModel?.draftOrder?.lineItems[indexPath.row].quantity -= 1
                    self.viewModel?.lineItems?[indexPath.row].quantity -= 1
                    //self.totalAmount.text = (Float(self.totalAmount.text ?? "0")! - (itemPrice ?? 0)).description
                }
            // add one item
            case 1:
                //self.viewModel?.draftOrder?.lineItems[indexPath.row].quantity += 1
                self.viewModel?.lineItems?[indexPath.row].quantity += 1
                //self.totalAmount.text = (Float(self.totalAmount.text ?? "0")! + (itemPrice ?? 0)).description
            default:
                return
            }
            self.viewModel?.updateDraftOrderLineItems(lineItems: (self.viewModel?.lineItems)!)
            //self.cartTable.reloadData()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 172
    }

}
