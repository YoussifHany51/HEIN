//
//  CurrencyTableViewCell.swift
//  HEIN
//
//  Created by Marco on 2024-09-07.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {

    @IBOutlet weak var currencyFullTerm: UILabel!
    @IBOutlet weak var currencyShort: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

