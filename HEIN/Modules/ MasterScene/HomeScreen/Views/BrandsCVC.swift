//
//  BrandsCVC.swift
//  HEIN
//
//  Created by Mahmoud  on 04/09/2024.
//

import UIKit

class BrandsCVC: UICollectionViewCell {
    @IBOutlet weak var imgBrands: UIImageView!
    
    @IBOutlet weak var view: UIView!
    static func nib()->UINib{
        return UINib(nibName: "BrandsCVC", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.red.cgColor
        view.layer.masksToBounds = false
        view.layer.cornerRadius = (view.frame.height)/8
        view.clipsToBounds = true
    }

}
