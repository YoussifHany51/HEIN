//
//  FavoriteVC.swift
//  HEIN
//
//  Created by Mahmoud  on 03/09/2024.
//

import UIKit

class FavoriteViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var favoriteTableView: UITableView!
    var favoriteProducts: [FavoriteProduct] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteTableView.dataSource = self
        favoriteTableView.delegate = self
        
        let favoriteCellNib = UINib(nibName: "FavoriteTableViewCell", bundle: nil)
        favoriteTableView.register(favoriteCellNib, forCellReuseIdentifier: "favoriteCell")
        navigationItem.title = "WhishList ♥️"
    }
    override func viewWillAppear(_ animated: Bool) {
        loadFavorites()
    }
    func loadFavorites() {
        favoriteProducts = FavoriteProductManager.shared.fetchFavorites()
        favoriteTableView.reloadData()
    }
    
}

extension FavoriteViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! FavoriteTableViewCell
        let favoriteProduct = favoriteProducts[indexPath.row]
        if let imageUrl = URL(string: favoriteProducts[indexPath.row].imageSrc ?? "cloud.slash") {
            cell.productImage.kf.setImage(with: imageUrl)
        }
        cell.productName.text = favoriteProduct.title
        cell.productPrice.text = favoriteProduct.price
        cell.productColor.text = favoriteProduct.color
        cell.productSize.text = favoriteProduct.size
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "ProductsInfoSB", bundle: nil)
        let selectedFavoriteProduct = favoriteProducts[indexPath.row]
        let product = Product(favoriteProduct: selectedFavoriteProduct) // Convert FavoriteProduct to Product

        let vc = storyboard.instantiateViewController(withIdentifier: "ProductsInfoViewController") as! ProductsInfoViewController
        vc.product = product
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 172
    }
}
