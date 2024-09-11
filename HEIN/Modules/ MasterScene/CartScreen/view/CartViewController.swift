//
//  CartViewController.swift
//  HEIN
//
//  Created by Mahmoud  on 05/09/2024.
//

import UIKit
import Kingfisher

class CartViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
   
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var discountAmount: UILabel!
    @IBOutlet weak var emptyCartLabel: UILabel!
    @IBOutlet weak var cartTableIndicator: UIActivityIndicatorView!
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
        cartTable.delegate = self
        cartTable.dataSource = self
        
        let cartCellNib = UINib(nibName: "CartTableViewCell", bundle: nil)
        cartTable.register(cartCellNib, forCellReuseIdentifier: "cartCell")
        
        viewModel = CartScreenViewModel()
        viewModel?.bindResultToViewController = {
            self.cartTableIndicator.stopAnimating()
            self.loadingView.isHidden = true
            
            if self.viewModel?.lineItems?.count == 0 {
                self.emptyCartLabel.isHidden = false
                self.totalAmount.text = "0"
            } else {
                self.totalAmount.text = self.viewModel?.draftOrder?.subtotalPrice
                if let discount = self.viewModel?.draftOrder?.appliedDiscount {
                    self.discountAmount.text = "\(discount.value) \(discount.valueType == "fixed_amount" ? "EGP" : "%")"
                    self.discountAmount.isHidden = false
                }
            }
            self.cartTable.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel?.getDraftOrder()
    }
    
    @IBAction func promoCodeAction(_ sender: Any) {
        guard let couponVc = self.storyboard?.instantiateViewController(withIdentifier: "coupons") else {return}
        
        if let presentationController = couponVc.presentationController as? UISheetPresentationController {
                  presentationController.detents = [.medium()]
              }
        
        self.present(couponVc, animated: true)
        //navigationController?.present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.lineItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartTable.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as! CartTableViewCell
        
        cell.productName.text = viewModel?.lineItems?[indexPath.row].name
        cell.productQuantity.text = viewModel?.lineItems?[indexPath.row].quantity.description
        
        let itemPrice = Float((viewModel?.lineItems?[indexPath.row].price)!)
        let itemQuantity = Float((viewModel?.lineItems?[indexPath.row].quantity)!)
        
        cell.productTotalAmount.text = (itemQuantity * itemPrice!).description
        
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
                        self.viewModel?.updateDraftOrder(lineItems: (self.viewModel?.lineItems)!)
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
            self.viewModel?.updateDraftOrder(lineItems: (self.viewModel?.lineItems)!)
            //self.cartTable.reloadData()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 172
    }

}

//@IBDesignable
class CustomButton: UIButton {
    @IBInspectable var isRounded: Bool = false {
        didSet {
            layer.cornerRadius = isRounded ? min(frame.width, frame.height) / 2 : 0
            layer.masksToBounds = isRounded ? true : false
        }
    }
}

//@IBDesignable
class CustomView: UIView {
    @IBInspectable var Rounded: Bool = false {
        didSet {
            layer.cornerRadius = Rounded ? 10 : 0
            //layer.masksToBounds = Rounded ? true : false
        }
    }
    
    @IBInspectable var Shadowed: Bool = false {
        didSet {
            layer.shadowRadius = 12
            layer.shadowOpacity = 0.28
            layer.shadowOffset = CGSize(width: 0, height: 4)
            layer.shadowColor = UIColor.gray.cgColor
            //layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
            //clipsToBounds = false
        }
    }

}

//@IBDesignable
class CustomImageView: UIImageView {
    @IBInspectable var Rounded: Bool = false {
        didSet {
            layer.cornerRadius = Rounded ? 10 : 0
            //layer.masksToBounds = Rounded ? true : false
        }
    }
    
    @IBInspectable var Shadowed: Bool = false {
        didSet {
            layer.shadowRadius = 12
            layer.shadowOpacity = 0.28
            layer.shadowOffset = CGSize(width: 0, height: 4)
            layer.shadowColor = UIColor.gray.cgColor
            //layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
            //clipsToBounds = false
        }
    }

}
