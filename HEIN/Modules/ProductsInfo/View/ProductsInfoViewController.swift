//
//  ProductsInfoViewController.swift
//  HEIN
//
//  Created by Youssif Hany on 10/09/2024.
//

import UIKit
import FirebaseAuth

class ProductsInfoViewController: UIViewController {
    
   
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var product : Product!
    
    var productsImageArray = [ProductImage]()
    var index = 0
    
    @IBOutlet weak var productTitle: UILabel!
    
    @IBOutlet weak var productType: UILabel!
    
    @IBOutlet weak var productPrice: UILabel!
   
    @IBOutlet weak var productDescription: UITextView!
    
    @IBOutlet weak var currentCurrency: UILabel!
    
    @IBOutlet weak var addToCartRef: UIButton!
    
    @IBOutlet weak var sizeButtonOutlet: UIButton!
    
    @IBOutlet weak var colorButtonOutlet: UIButton!
    
    @IBOutlet weak var addToFavRef: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(scrollingProductImagessetup), userInfo: nil,repeats:true)
        
        title = product.vendor
        
        pageControl.numberOfPages = productsImageArray.count

        setUpData()
    }
    override func viewWillAppear(_ animated: Bool) {
        updateFavoriteButton(for: product)
    }
    @IBAction func addToFavoriteButton(_ sender: Any) {
        if Auth.auth().currentUser != nil{
            toggleFavorite(product: product)
        }else{
            // ShowAlert
        }
    }
    
    @IBAction func addToCartButton(_ sender: Any) {
        print("Add to Cart")
    }
    
    @IBAction func sizeButton(_ sender: Any) {
        guard let options = product.options.first?.values else { return }
           
           // Create a UIAlertController with action sheet style
           let alertController = UIAlertController(title: "Select Size", message: nil, preferredStyle: .actionSheet)
           
           // Add an action for each option
           for option in options {
               let action = UIAlertAction(title: option, style: .default) { action in
                   // Handle the selection here
                   print("Selected size: \(option)")
                   // You can also update the button title or any other UI based on the selection
                   self.sizeButtonOutlet.setTitle(option, for: .normal)
               }
               alertController.addAction(action)
           }
           
           // Add a cancel action
           let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
           alertController.addAction(cancelAction)
           
           // Present the alert controller
           if let popoverController = alertController.popoverPresentationController {
               popoverController.sourceView = sender as? UIView
               popoverController.sourceRect = (sender as AnyObject).bounds
           }
           present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func colorButton(_ sender: Any) {
        guard let colorOption = product.options.first(where: { $0.name == .color }) else{ return }
           // Create a UIAlertController with action sheet style
           let alertController = UIAlertController(title: "Select Color", message: nil, preferredStyle: .actionSheet)
           
           // Add an action for each option
        for option in colorOption.values {
               let action = UIAlertAction(title: option, style: .default) { action in
                   // Handle the selection here
                   print("Selected color: \(option)")
                   // You can also update the button title or any other UI based on the selection
                   self.colorButtonOutlet.setTitle(option, for: .normal)
               }
               alertController.addAction(action)
           }
           
           // Add a cancel action
           let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
           alertController.addAction(cancelAction)
           
           // Present the alert controller
           if let popoverController = alertController.popoverPresentationController {
               popoverController.sourceView = sender as? UIView
               popoverController.sourceRect = (sender as AnyObject).bounds
           }
           present(alertController, animated: true, completion: nil)
    }
    func setUpData(){
        productsImageArray = self.product.images
        productTitle.text = self.product.title
        productTitle.sizeToFit()
        productType.text = self.product.productType.rawValue
        productPrice.text = self.product.variants.first?.price
        productDescription.text = self.product.bodyHTML
        productDescription.sizeToFit()
        addToCartRef.tintColor = .red
        productDescription.isScrollEnabled = true
        productDescription.contentInsetAdjustmentBehavior = .never
        addToFavRef.tintColor = .red
        updateFavoriteButton(for: product)
    }
    
    @objc func scrollingProductImagessetup(){
        if index < productsImageArray.count - 1 {
            index += 1
        }
        else {
            index = 0
        }
        pageControl.numberOfPages = productsImageArray.count
        pageControl.currentPage = index
        collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .right, animated:true)
    }
    
    func toggleFavorite(product: Product) {
        let favorites = FavoriteProductManager.shared.fetchFavorites()
        
        if favorites.contains(where: { $0.id == Int64(product.id) }) {
            FavoriteProductManager.shared.removeProductFromFavorites(productID: product.id)
            updateFavoriteButton(for: product)
            print("Product removed from favorites")
        } else {
            FavoriteProductManager.shared.addProductToFavorites(product: product)
            updateFavoriteButton(for: product)
            print("Product added to favorites")
        }
    }
    func updateFavoriteButton(for product: Product) {
        let favorites = FavoriteProductManager.shared.fetchFavorites()
        
        if favorites.contains(where: { $0.id == Int64(product.id) }) {
            addToFavRef.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            addToFavRef.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
}

extension ProductsInfoViewController: UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productsImageArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImageCollectionViewCell", for: indexPath) as? ProductImageCollectionViewCell
        if let imageUrl = URL(string: productsImageArray[indexPath.row].src) {
            cell?.productImage.kf.setImage(with: imageUrl)
        }
        cell?.layer.borderWidth = 1
        cell?.layer.borderColor = UIColor.white.cgColor
        cell?.layer.cornerRadius = 20
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
