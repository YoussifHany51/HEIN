//
//  CouponsTableViewCell.swift
//  HEIN
//
//  Created by Marco on 2024-09-11.
//

import UIKit

class CouponsTableViewCell: UITableViewCell {

    @IBOutlet weak var discountRemaningDays: UILabel!
    @IBOutlet weak var discountCode: UILabel!
    @IBOutlet weak var discountTitle: UILabel!
    
    var applyDiscount : (() -> Void) = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func applyDiscount(_ sender: Any) {
        applyDiscount()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
