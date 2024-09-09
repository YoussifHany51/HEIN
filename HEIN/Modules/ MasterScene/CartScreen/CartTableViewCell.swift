//
//  CartTableViewCell2.swift
//  HEIN
//
//  Created by Marco on 2024-09-04.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var addOneProductButton: CustomButton!
    @IBOutlet weak var removeOneProductButton: CustomButton!
    @IBOutlet weak var productOption2_Value: UILabel!
    @IBOutlet weak var productOption1_Value: UILabel!
    @IBOutlet weak var productOption2: UILabel!
    @IBOutlet weak var productOption1: UILabel!
    @IBOutlet weak var productTotalAmount: UILabel!
    @IBOutlet weak var productQuantity: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    var changeProductQuantity : ((_ tag: Int) -> Void) = {tag in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func changeProductQuantity(_ sender: UIButton) {
        switch sender.tag{
        case 0:
            self.changeProductQuantity(0)
        case 1:
            self.changeProductQuantity(1)
        default:
            return
        }
    }
}
