//
//  CategoryViewController.swift
//  HEIN
//
//  Created by Youssif Hany on 03/09/2024.
//

import UIKit

class CategoryViewController: UIViewController {

    @IBOutlet weak var categoryCollection: UICollectionView!
    @IBOutlet weak var categorySeg: UISegmentedControl!
    @IBOutlet weak var genderSeg: UISegmentedControl!
    
    @IBOutlet weak var noProductsImg: UIImageView!
    var category : String?
    var subCategory : String?
    var indicator : UIActivityIndicatorView?
    var categoriesViewModel : CategoryProtocol!
    var alert:UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setIndicator()
        noProductsImg.isHidden = true
        categoriesViewModel = CategoriesViewModel()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        categoryCollection.delegate = self
        categoryCollection.dataSource = self
        registerCell()
        setupSegmentesControl()
        setupCollectionView()
        self.hideKeyboardWhenTappedAround()
        categoriesViewModel.checkNetworkReachability{ isReachable in
          
            if isReachable {
                self.loadData()
                self.genderSeg.selectedSegmentIndex = 0
                self.categorySeg.selectedSegmentIndex = 0
                
            } else {
                DispatchQueue.main.async {
                   self.showAlert()
                   // self.alert.showAlert(self: self)
                }
            }
        }
    }
    
    @IBAction func searchBar(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SearchButtonSB", bundle: nil)
        let seearcchVC = storyboard.instantiateViewController(withIdentifier: "SearchButtonViewController") as! SearchButtonViewController //{
       
        self.present(seearcchVC, animated: true)
        
    }
    
    
   
}
// MARK: - UISetUp

extension CategoryViewController{
    func setIndicator(){
        indicator = UIActivityIndicatorView(style: .large)
        indicator?.color = .black
        indicator?.center = self.categoryCollection.center
        indicator?.startAnimating()
        self.view.addSubview(indicator!)
        
    }
    func setupCollectionView(){
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        categoryCollection.setCollectionViewLayout(layout, animated: true)
        
    }
    func registerCell(){
        categoryCollection.register(BrandProductsCVC.nib(), forCellWithReuseIdentifier: "BrandProductsCVC")
    }
    func setupSegmentesControl(){
        genderSeg.addTarget(self, action: #selector(segmentedControlCategoryChanged(_:)), for: .valueChanged)
        categorySeg.addTarget(self, action: #selector(segmentedControlSuCategoryChanged(_:)), for: .valueChanged)
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
// MARK: - UIcollectionView

extension CategoryViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categoriesViewModel.filteredResultArr?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = categoryCollection.dequeueReusableCell(withReuseIdentifier: "BrandProductsCVC", for: indexPath) as! BrandProductsCVC
        cell.configureCell(product: categoriesViewModel.filteredResultArr?[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "ProductsInfoSB", bundle: nil)
        let productInfovc = storyboard.instantiateViewController(withIdentifier: "ProductsInfoViewController") as! ProductsInfoViewController //{
        productInfovc.product = categoriesViewModel.filteredResultArr?[indexPath.row]
        self.present(productInfovc, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthPerItem = categoryCollection.frame.width / 2 - 10
        let heightPerItem = categoryCollection.frame.height / 2 - 20
        return CGSize(width:widthPerItem, height:heightPerItem)
        }
              
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
            return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5)
    }
    
}
// MARK: - getData

extension CategoryViewController{
    func loadData(){
        categoriesViewModel.loadData()
        categoriesViewModel.bindProductToViewController = { [weak self] in
            DispatchQueue.main.async {
                
                self?.filterResults()
                
                
            }
        }
    }
    
    
    @objc func segmentedControlCategoryChanged(_ sender: Any) {
        category = genderSeg.titleForSegment(at: genderSeg.selectedSegmentIndex) ?? "All"
        print("Selected Category: \(String(describing: category))")
        filterResults(category: category ?? "All", subCategory: subCategory ?? "All")
    }

    @objc func segmentedControlSuCategoryChanged(_ sender: Any) {
        subCategory = categorySeg.titleForSegment(at: categorySeg.selectedSegmentIndex) ?? "All"
        print("Selected SubCategory: \(String(describing: subCategory))")
        filterResults(category: category ?? "All", subCategory: subCategory ?? "All")
    }

    func filterResults(category:String = "All",subCategory: String = "All"){
        indicator?.stopAnimating()
        
        if category == "Women"{
            categoriesViewModel.filteredResultArr = categoriesViewModel.women
           
        }else if category == "Men"{
            categoriesViewModel.filteredResultArr = categoriesViewModel.men
            
        }else if category == "Kids"{
            categoriesViewModel.filteredResultArr = categoriesViewModel.kid
            
        }else if category == "All"{
            categoriesViewModel.filteredResultArr = categoriesViewModel.AllProducct?.products
            
        }
        if subCategory != "All"{
            
            categoriesViewModel.filteredResultArr =   categoriesViewModel.filteredResultArr?.filter{
                $0.productType.rawValue == subCategory.uppercased()
            } ?? []
            }
        checkIfNoProducts()
        categoryCollection.reloadData()
    }
    func checkIfNoProducts(){
        if (categoriesViewModel.filteredResultArr?.count  == 0) {
            categoryCollection.isHidden = true
            noProductsImg.isHidden = false
        } else {
            categoryCollection.isHidden = false
            noProductsImg.isHidden = true
        }
    }

}


