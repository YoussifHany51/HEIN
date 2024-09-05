//
//  CartViewController.swift
//  HEIN
//
//  Created by Youssif Hany on 03/09/2024.
//

import UIKit

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var cartTable: UITableView!
    @IBOutlet weak var promoCodeButton: UIButton!
    @IBOutlet weak var promoCodeField: UITextField!
    @IBOutlet weak var currency: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var checkOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        cartTable.delegate = self
        cartTable.dataSource = self
        
        let cartCellNib = UINib(nibName: "CartTableViewCell", bundle: nil)
        cartTable.register(cartCellNib, forCellReuseIdentifier: "cartCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartTable.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as! CartTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 152
    }

}

@IBDesignable
class CustomButton: UIButton {
    @IBInspectable var isRounded: Bool = false {
        didSet {
            layer.cornerRadius = isRounded ? min(frame.width, frame.height) / 2 : 0
            layer.masksToBounds = isRounded ? true : false
        }
    }
}

@IBDesignable
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
