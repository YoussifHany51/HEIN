//
//  BrandsViewController.swift
//  HEIN
//
//  Created by Mahmoud  on 07/09/2024.
//

import UIKit

class BrandsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, UISearchBarDelegate,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var noProductsImg: UIImageView!
    @IBOutlet weak var BrandProductsCollection: UICollectionView!
    @IBOutlet weak var imgBrand: UIImageView!
    @IBOutlet weak var productNumbers: UILabel!
    
    var brandsViewModel : BrandsProtocol!
    var indicator : UIActivityIndicatorView?
    var vendor : String?
    var brandImage : String?
    var flag = false
    var searchWord = ""
    var searching = false
    var back:UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        back = UIBarButtonItem(image: UIImage(systemName: "arrowshape.turn.up.backward"), style: .plain, target: self, action: #selector(backButton))
        noProductsImg.isHidden = true
        self.hideKeyboardWhenTappedAround()
        brandsViewModel = BrandsViewMode()
        setIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        BrandProductsCollection.delegate = self
        BrandProductsCollection.dataSource = self
        setupCollectionView()
        searchBar.delegate = self
        registerCell()
        brandsViewModel?.checkNetworkReachability{ isReachable in
            if isReachable {
                self.loadData()
            } else {
                DispatchQueue.main.async {
                    self.showAlert()
                }
            }
        }
    }
    
    @IBAction func sortedByPrice(_ sender: Any) {
        brandsViewModel.sortByPrice()
        flag = !flag
        BrandProductsCollection.reloadData()
    }
    

    func loadData(){
        brandsViewModel.loadData()
        brandsViewModel.bindBrandsToViewController = {[weak self] in
            self?.indicator?.stopAnimating()
            self?.display()
            self?.BrandProductsCollection.reloadData()
            self?.imgBrand?.kf.setImage(with: URL(string: self?.brandImage ?? "PlaceHolder"),placeholder: UIImage(named: "PlaceHolder"))
            self?.productNumbers.text =  "\(self?.brandsViewModel.brandProducts?.count ?? 0) Items"
        }
    }
}


// Mark:-  Setup UI

extension BrandsViewController{
    func display() {
        brandsViewModel?.getBrands(vendor: vendor ?? " ")
        if (brandsViewModel?.brandProducts?.count  == 0) {
            BrandProductsCollection.isHidden = true
            noProductsImg.isHidden = false
        } else {
            BrandProductsCollection.isHidden = false
            noProductsImg.isHidden = true
        }
        
    }
     @objc func backButton() {
         self.navigationController?.popViewController(animated: true)
        }
    func registerCell(){
        BrandProductsCollection.register(BrandProductsCVC.nib(), forCellWithReuseIdentifier: "BrandProductsCVC")
    }
    func setupCollectionView(){
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        BrandProductsCollection.setCollectionViewLayout(layout, animated: true)
        
    }
    
    func setIndicator(){
        indicator = UIActivityIndicatorView(style: .large)
        indicator?.color = .black
        indicator?.center = self.BrandProductsCollection.center
        indicator?.startAnimating()
        self.view.addSubview(indicator!)
        
    }
    func showAlert(){
        let alertController = UIAlertController(title: "No Internet Connection", message: "Check your network and try again", preferredStyle: .alert)
        
        let doneAction = UIAlertAction(title: "Retry", style: .cancel) { _ in
            self.viewWillAppear(true)
        }
        
        alertController.addAction(doneAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

//    Mark:- Draw Collection

extension BrandsViewController{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if flag == false{
            return brandsViewModel.brandProducts?.count ?? 0
        }else{
            return brandsViewModel.sortedProducts?.count ?? 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = BrandProductsCollection.dequeueReusableCell(withReuseIdentifier: "BrandProductsCVC", for: indexPath) as! BrandProductsCVC
        if flag == false {
            cell.configureCell(product: brandsViewModel.brandProducts?[indexPath.row])
        }else{
            cell.configureCell(product: brandsViewModel.sortedProducts?[indexPath.row])
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "ProductsInfoSB", bundle: nil)
        let productInfovc = storyboard.instantiateViewController(withIdentifier: "ProductsInfoViewController") as! ProductsInfoViewController //{
        productInfovc.product = brandsViewModel.brandProducts?[indexPath.row]
        productInfovc.navigationItem.title = "HEIN"
        productInfovc.navigationItem.leftBarButtonItem = back
        
        navigationController?.pushViewController(productInfovc, animated: true)
        //self.present(productInfovc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthPerItem = BrandProductsCollection.frame.width / 2 - 10
        let heightPerItem = BrandProductsCollection.frame.height / 2 - 20
        return CGSize(width:widthPerItem, height:heightPerItem)
        }
              
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
            return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5)
    }
    
   
    
}


//   Mark:-   SearchBar

extension BrandsViewController {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searching = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searching = false
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchWord = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        print("Search text: \(searchWord)")
        searchingResult()
    }
    
    
    func searchingResult(){
        if searching == false  {
            display()
        }else{
            if searchWord.isEmpty{
                display()
            }else{
                if flag == false{
            brandsViewModel.searchBrands(text: searchWord.lowercased())
                }else{
            brandsViewModel.searchSorted(text: searchWord.lowercased())
                }
            }
        }
        BrandProductsCollection.reloadData()
    }
}



