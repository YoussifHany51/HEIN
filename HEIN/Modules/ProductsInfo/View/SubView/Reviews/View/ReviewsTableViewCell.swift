//
//  ReviewsTableViewCell.swift
//  HEIN
//
//  Created by Youssif Hany on 17/09/2024.
//

import UIKit

class ReviewsTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var decription: UITextView!
    @IBOutlet weak var dateCreated: UILabel!
    
    @IBOutlet weak var rating: UILabel!
    
    @IBOutlet weak var userImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        decription.isScrollEnabled = false
        decription.isEditable = false
        decription.textContainer.lineBreakMode = .byWordWrapping
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
