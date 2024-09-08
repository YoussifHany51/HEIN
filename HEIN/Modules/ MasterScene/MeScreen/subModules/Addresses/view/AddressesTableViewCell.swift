//
//  AddressesTableViewCell.swift
//  HEIN
//
//  Created by Marco on 2024-09-07.
//

import UIKit

class AddressesTableViewCell: UITableViewCell {

    @IBOutlet weak var addressPhone: UILabel!
    @IBOutlet weak var addressName: UILabel!
    @IBOutlet weak var isDefault: UISwitch!
    @IBOutlet weak var addressCountry: UILabel!
    @IBOutlet weak var addressCity: UILabel!
    @IBOutlet weak var addressStreet: UILabel!
    
    var changeDefaultAddress : (() -> Void) = {}
    var editAddress : (() -> Void) = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func changeDefaultAddress(_ sender: Any) {
        changeDefaultAddress()
    }

    @IBAction func editAddressButtonAction(_ sender: Any) {
        editAddress()
    }
}
