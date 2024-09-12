//
//  CouponsViewController.swift
//  HEIN
//
//  Created by Marco on 2024-09-11.
//

import UIKit

class CouponsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var emptyCouponsTableLabel: UILabel!
    @IBOutlet weak var couponsTableIndicator: UIActivityIndicatorView!
    @IBOutlet weak var couponsTable: UITableView!
    
    var draftOrder: DraftOrder?
    
    var viewModel: CouponsViewModel?
    
    var ref : CartProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        couponsTable.delegate = self
        couponsTable.dataSource = self
        
        viewModel = CouponsViewModel(draftOrder: draftOrder!)
        viewModel?.bindResultToViewController = { binding in
            switch binding {
            case .priceRulesReady:
                self.loadingView.isHidden = true
                self.couponsTableIndicator.stopAnimating()
                self.emptyCouponsTableLabel.isHidden = self.viewModel?.priceRules?.count ?? 0 > 0
            case .appliedDiscount:
                self.ref?.updateCartTable(draftOrder: self.viewModel?.draftOrder)
                self.dismiss(animated: true, completion: nil)
            }
            
            self.couponsTable.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.priceRules?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = couponsTable.dequeueReusableCell(withIdentifier: "couponCell", for: indexPath) as! CouponsTableViewCell
        
        cell.discountTitle.text = viewModel?.priceRules?[indexPath.row].title
        cell.discountRemaningDays.text =  "\((viewModel?.priceRules?[indexPath.row].endsAt)!.prefix(10))"
        cell.applyDiscount = {
            self.loadingView.isHidden = false
            self.couponsTableIndicator.startAnimating()
            self.viewModel?.updateDraftOrder(priceRule: (self.viewModel?.priceRules?[indexPath.row])!)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 124
    }

}
