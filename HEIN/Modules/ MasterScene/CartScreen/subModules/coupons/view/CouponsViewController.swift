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
        
        setViewModel()
    }
    
    func setViewModel() {
        viewModel = CouponsViewModel(draftOrder: draftOrder!)
        viewModel?.bindResultToViewController = { binding in
            switch binding {
            case .priceRulesReady:
                self.loadingView.isHidden = self.viewModel?.priceRules?.count ?? 0 > 0
                self.couponsTableIndicator.stopAnimating()
                self.emptyCouponsTableLabel.isHidden = self.viewModel?.priceRules?.count ?? 0 > 0
            case .appliedDiscount:
                self.ref?.updateCartTable(draftOrder: self.viewModel?.draftOrder)
                self.dismiss(animated: true, completion: nil)
            }
            
            self.couponsTable.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ReachabilityManager.checkNetworkReachability { isReachable in
            if !isReachable {
                ReachabilityManager.showConnectionAlert(view: self)
            }
        }
    }
    
    @IBAction func dismisCoupons(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.priceRules?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = couponsTable.dequeueReusableCell(withIdentifier: "couponCell", for: indexPath) as! CouponsTableViewCell
        
        cell.discountTitle.text = viewModel?.priceRules?[indexPath.row].title
        cell.discountRemaningDays.text =  "\((viewModel?.priceRules?[indexPath.row].endsAt)!.prefix(10))"
        cell.discountCode.text = (viewModel?.discountCodes.first(where: { discount in
            discount.priceRuleId == viewModel?.priceRules?[indexPath.row].id
        }) )?.code
        cell.applyDiscount = {
            self.loadingView.isHidden = false
            self.couponsTableIndicator.startAnimating()
            self.viewModel?.updateDraftOrder(priceRule: (self.viewModel?.priceRules?[indexPath.row])!, discountCode: (self.viewModel?.discountCodes.first(where: {
                $0.priceRuleId == (self.viewModel?.priceRules?[indexPath.row].id)!
            }))!.code )
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 124
    }

}
