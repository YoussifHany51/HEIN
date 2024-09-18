//
//  FavoriteTableViewCell.swift
//  HEIN
//
//  Created by Youssif Hany on 14/09/2024.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var productName: UILabel!
    
    @IBOutlet weak var productColor: UILabel!
    
    @IBOutlet weak var productSize: UILabel!
    
    @IBOutlet weak var productPrice: UILabel!
    
    @IBOutlet weak var currCurrency: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
