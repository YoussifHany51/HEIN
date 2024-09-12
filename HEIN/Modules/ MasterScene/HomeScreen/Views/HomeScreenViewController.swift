
//  HomeScreenViewController.swift
//  HEIN
//  Created by Youssif Hany on 03/09/2024.

import UIKit
import Kingfisher

class HomeScreenViewController: UIViewController {
    
    @IBOutlet weak var adsCollection: UICollectionView!
    
    @IBOutlet weak var brandsCollection: UICollectionView!
    var indicator : UIActivityIndicatorView?
    var viewModel:HomeProtocol!
    var photoarr = [UIImage(named: "sale1"),UIImage(named: "sale2"),UIImage(named: "sale3"),UIImage(named: "sale4"),UIImage(named: "sale5"),UIImage(named: "sale6")]
    var search:UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = HomeViewModel()
        self.navigationItem.hidesBackButton = true
        self.tabBarController?.navigationItem.hidesBackButton = true
        setIndicator()
       
//search = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(productSearch))
        //self.tabBarController?.navigationItem.leftBarButtonItem = search
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupCollectionView()
        
        self.registerCells()
        adsCollection.delegate = self
        adsCollection.dataSource = self
        brandsCollection.delegate = self
        brandsCollection.dataSource = self
       viewModel?.checkNetworkReachability{ isReachable in
            print(isReachable)
            if isReachable {
                self.loadData()
                self.adsCollection.reloadData()
                self.brandsCollection.reloadData()
            } else {
                DispatchQueue.main.async {
                    self.showConnectionAlert()
                }}}
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        brandsCollection.collectionViewLayout.invalidateLayout()
    }
    
     func loadData(){
        
         viewModel?.loadBrandCollectionData()
         viewModel?.bindBrandsToViewController = { [weak self] in
             DispatchQueue.main.async {
                 self?.brandsCollection.reloadData()
             }
             
         }
         viewModel?.loadAdsCollectionData()
         viewModel?.bindAdsToViewController = { [weak self] in
             DispatchQueue.main.async {
                 self?.indicator?.stopAnimating()
                 self?.adsCollection.reloadData()
             }}}
     
    @objc func productSearch(){
        
    }
}


//   Mark:- Setup UI

extension HomeScreenViewController{
    func setIndicator(){
        indicator = UIActivityIndicatorView(style: .large)
        indicator?.color = .black
        indicator?.center = self.brandsCollection.center
        indicator?.startAnimating()
        self.view.addSubview(indicator!)
        
    }
    func registerCells(){
        brandsCollection.register(BrandsCVC.nib(), forCellWithReuseIdentifier: "BrandsCVC")
    }
    func setupCollectionView(){
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        brandsCollection.setCollectionViewLayout(layout, animated: true)
        
    }
    func showConnectionAlert(){
        let alertController = UIAlertController(title: "No Internet Connection", message: "Check your network and try again", preferredStyle: .alert)
        
        let doneAction = UIAlertAction(title: "Retry", style: .cancel) { _ in
            self.viewWillAppear(true)
        }
        
        alertController.addAction(doneAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}


//   Mark:- Draw Collections

extension  HomeScreenViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == adsCollection{return photoarr.count }
        else{return viewModel?.brands?.count ?? 0}
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == adsCollection{
            let cell = adsCollection.dequeueReusableCell(withReuseIdentifier: "AdsCVC", for: indexPath) as! AdsCVC
            cell.imgAds.image = photoarr[indexPath.row]
            return cell
        }else{
            let cell = brandsCollection.dequeueReusableCell(withReuseIdentifier: "BrandsCVC", for: indexPath) as! BrandsCVC
            let url = URL(string:viewModel.brands?[indexPath.row].image.src ?? "placeHolder")
            cell.imgBrands.kf.setImage(with:url ,placeholder: UIImage(named: "placeHolder"))
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == brandsCollection{
            let brandsVC = storyboard?.instantiateViewController(identifier: "BrandsViewController")as! BrandsViewController
            brandsVC.vendor = viewModel.brands?[indexPath.row].title
            brandsVC.brandImage = viewModel.brands?[indexPath.row].image.src
            navigationController?.pushViewController(brandsVC, animated: true)
        }else{
            
           
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                if collectionView == adsCollection{
                    return CGSize(width: (UIScreen.main.bounds.width) - 50, height: (adsCollection.frame.height) - 50)
                } else{
                    let widthPerItem = brandsCollection.frame.width / 2 - 5
                    let heightPerItem = brandsCollection.frame.height / 2 - 20
                    return CGSize(width:widthPerItem, height:heightPerItem)
                }
            }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == brandsCollection {
            return 15
        } else {
            return 0
        }
    }
        
    }

