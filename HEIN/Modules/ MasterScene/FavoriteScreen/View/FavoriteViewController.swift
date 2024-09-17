//
//  FavoriteVC.swift
//  HEIN
//
//  Created by Mahmoud  on 03/09/2024.
//

import UIKit

class FavoriteViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var favoriteTableView: UITableView!
    
    var viewModel : FavoriteViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteTableView.dataSource = self
        favoriteTableView.delegate = self
        
        let favoriteCellNib = UINib(nibName: "FavoriteTableViewCell", bundle: nil)
        favoriteTableView.register(favoriteCellNib, forCellReuseIdentifier: "favoriteCell")
        navigationItem.title = "WhishList ♥️"
        viewModel = FavoriteViewModel()
    }
    override func viewWillAppear(_ animated: Bool) {
        viewModel?.loadFavorites()
        favoriteTableView.reloadData()
        favoriteHasData()
    }
    
    func favoriteHasData(){
        if viewModel?.favoriteProducts.isEmpty ?? true {
              favoriteTableView.isHidden = true
              if let imgErrorPhoto = self.view.viewWithTag(100) as? UIImageView {
                  imgErrorPhoto.isHidden = false
              } else {
                  let imgErrorPhoto = UIImageView(frame: CGRect(x: 50, y: 100, width: self.view.frame.width - 100, height: 200))
                  imgErrorPhoto.image = UIImage(named: "NoProducts")
                  imgErrorPhoto.tintColor = .gray
                  imgErrorPhoto.tag = 100 // Set a tag to identify the image view
                  self.view.addSubview(imgErrorPhoto)
              }
              
          } else {
              favoriteTableView.isHidden = false
              if let imgErrorPhoto = self.view.viewWithTag(100) as? UIImageView {
                  imgErrorPhoto.isHidden = true
              }
          }
    }
}

extension FavoriteViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.favoriteProducts.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! FavoriteTableViewCell
        let favoriteProduct = viewModel?.favoriteProducts[indexPath.row]
        if let imageUrl = URL(string: viewModel?.favoriteProducts[indexPath.row].imageSrc ?? "cloud.slash") {
            cell.productImage.kf.setImage(with: imageUrl)
        }
        cell.productName.text = favoriteProduct?.title
        cell.productPrice.text = favoriteProduct?.price
        cell.productColor.text = favoriteProduct?.color
        cell.productSize.text = favoriteProduct?.size
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "ProductsInfoSB", bundle: nil)
        let selectedFavoriteProduct = (viewModel?.favoriteProducts[indexPath.row])!
        let product = Product(favoriteProduct: selectedFavoriteProduct) // Convert FavoriteProduct to Product

        let vc = storyboard.instantiateViewController(withIdentifier: "ProductsInfoViewController") as! ProductsInfoViewController
        vc.product = product
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 172
    }
}
