//
//  PaymentTableViewCell.swift
//  HEIN
//
//  Created by Marco on 2024-09-14.
//

import UIKit

class PaymentTableViewCell: UITableViewCell {

    @IBOutlet weak var paymentMethodIsSelectedImage: CustomImageView!
    @IBOutlet weak var paymentMethodName: UILabel!
    @IBOutlet weak var paymentMethodImage: CustomImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
