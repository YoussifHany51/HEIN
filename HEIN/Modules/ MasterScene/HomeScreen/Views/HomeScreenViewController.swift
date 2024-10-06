
//  HomeScreenViewController.swift
//  HEIN
//  Created by Youssif Hany on 03/09/2024.

import UIKit
import Kingfisher

class HomeScreenViewController: UIViewController {
    
    @IBOutlet weak var adsCollection: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var brandsCollection: UICollectionView!
    var indicator : UIActivityIndicatorView?
    var viewModel:HomeProtocol!
    var photoarr = [(image: UIImage(named: "sale1"), code: "SUMMERSALE50FF"), (image: UIImage(named: "sale3"), code: "SUMMERSALE20FF"), (image: UIImage(named: "sale5"), code: "LAST10WAITING")]
    var back:UIBarButtonItem!
    var timer : Timer?
    
    private var currentIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        back = UIBarButtonItem(image: UIImage(systemName: "arrowshape.turn.up.backward"), style: .plain, target: self, action: #selector(backButton))
        back.tintColor = UIColor.red
        pageControl.numberOfPages = photoarr.count
        viewModel = HomeViewModel()
        setIndicator()
        pageControl.currentPage = currentIndexPath.item
        startTimer()
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
     
    @IBAction func homeSearch(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SearchButtonSB", bundle: nil)
        let seearcchVC = storyboard.instantiateViewController(withIdentifier: "SearchButtonViewController") as! SearchButtonViewController
       
        self.present(seearcchVC, animated: true)
    }
    deinit {
        stopTimer()
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
        
        let layout2 = UICollectionViewCompositionalLayout{ indexPath, enviroment in
            return self.drawSection()
        }
        adsCollection.setCollectionViewLayout(layout2, animated: true)
        
    }
    func showConnectionAlert(){
        let alertController = UIAlertController(title: "No Internet Connection", message: "Check your network and try again", preferredStyle: .alert)
        
        let doneAction = UIAlertAction(title: "Retry", style: .cancel) { _ in
            self.viewWillAppear(true)
        }
        
        alertController.addAction(doneAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { action in
            return
        }))
        self.present(alert, animated: true)
    }
    @objc func backButton() {
        self.navigationController?.popViewController(animated: true)
       }
    @objc private func scrollToNextItem() {
            let numberOfItems = adsCollection.numberOfItems(inSection: currentIndexPath.section)
            if numberOfItems > 0 {
                // Calculate the next item index
                let nextItem = (currentIndexPath.item + 1) % numberOfItems
                let nextIndexPath = IndexPath(item: nextItem, section: currentIndexPath.section)
                
                // Scroll to the next item
                adsCollection.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
                
                currentIndexPath = nextIndexPath
            }
        }
    //Invokes Timer to start Automatic Animation with repeat enabled
    func startTimer() {
        // To Restart the timer
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(scrollToNextItem), userInfo: nil, repeats: true);
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
    
    // Scroll to Next Cell
    
}


//   Mark:- Draw Collections
extension HomeScreenViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == adsCollection{return photoarr.count }
        else{return viewModel?.brands?.count ?? 0}
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == adsCollection{
            let cell = adsCollection.dequeueReusableCell(withReuseIdentifier: "AdsCVC", for: indexPath) as! AdsCVC
            cell.imgAds.image = photoarr[indexPath.row].image
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
            //self.present(brandsVC, animated: true)
            brandsVC.navigationItem.leftBarButtonItem = back
            brandsVC.navigationItem.title = "HEIN"
            self.navigationController?.pushViewController(brandsVC, animated: true)
        }else{
            if UserDefaults.standard.string(forKey: "User_id") != nil {
                if UserDefaults.standard.string(forKey: "coupon\(indexPath.row)") == nil {
                    UserDefaults.standard.set(photoarr[indexPath.row].code, forKey: "coupon\(indexPath.row)")
                    showAlert(title: "'\(photoarr[indexPath.row].code)'", message: "Coupon added to your coupons")
                } else if UserDefaults.standard.string(forKey: "coupon\(indexPath.row)") == "used" {
                    showAlert(title: "Coupon used", message: "")
                } else {
                    showAlert(title: "Coupon already added", message: "")
                }
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                if collectionView == adsCollection{
                    return CGSize(width: view.frame.width, height: adsCollection.frame.height)
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
    
    func drawSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.orthogonalScrollingBehavior = .paging
        
        section.visibleItemsInvalidationHandler = { [weak self] visibleItems, point, environment in
            self?.startTimer()
            let indexPath = visibleItems.last!.indexPath
            self?.currentIndexPath = indexPath
            self?.pageControl.currentPage = indexPath.item
        }
        
        return section
    }
}

