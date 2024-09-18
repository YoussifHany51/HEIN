//
//  BrandProductsCVC.swift
//  HEIN
//
//  Created by Mahmoud  on 07/09/2024.
//

import UIKit

class BrandProductsCVC: UICollectionViewCell {

    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var viewBack: UIView!
    
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var productName: UILabel!
    
    @IBOutlet weak var currency: UILabel!
    @IBOutlet weak var productBrand: UILabel!
    
    static func nib()->UINib{
        return UINib(nibName: "BrandProductsCVC", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        viewBack.layer.cornerRadius = 10
        imgProduct.layer.cornerRadius = 10
        viewBack.layer.borderWidth = 1
        viewBack.layer.borderColor = UIColor.red.cgColor
    }
    
    
    func configureCell(product:Product?){
        guard let url = URL(string: product?.image.src ?? "") else{return}
        imgProduct.kf.setImage(with: url,placeholder:UIImage(named: "placeHolder"))
        price.text = ExchangeCurrency.exchangeCurrency(amount: product?.variants.first?.price)
        productName.text = product?.title
        productBrand.text = product?.vendor
        currency.text =  ExchangeCurrency.getCurrency()
    }

}



