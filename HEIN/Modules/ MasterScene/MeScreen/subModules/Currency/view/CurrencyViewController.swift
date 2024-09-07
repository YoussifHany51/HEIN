//
//  CurrencyViewController.swift
//  HEIN
//
//  Created by Marco on 2024-09-07.
//

import UIKit

class CurrencyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var selectedCurrency: UILabel!
    @IBOutlet weak var currencyTableIndicator: UIActivityIndicatorView!
    @IBOutlet weak var currencySearchBar: UISearchBar!
    @IBOutlet weak var currenciesTable: UITableView!
    
    var viewModel : CurrencyViewModel?
    
    var filterdCurrencies : [(short: String, full: String)]?{
        didSet {
            currencyTableIndicator.stopAnimating()
            currencyTableIndicator.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        currenciesTable.delegate = self
        currenciesTable.dataSource = self
        
        currencyTableIndicator.startAnimating()
        
        viewModel = CurrencyViewModel()
        viewModel?.bindResultToViewController = { [weak self] in
            if self?.viewModel?.allCurrencies != nil {
                self?.filterdCurrencies  = self?.viewModel?.allCurrencies
                self?.currencyTableIndicator.stopAnimating()
                self?.currencyTableIndicator.isHidden = true
            } else {
                self?.emptyLabel.isHidden = false
                self?.currencyTableIndicator.stopAnimating()
                self?.currencyTableIndicator.isHidden = true
            }
            
            self?.currenciesTable.reloadData()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterdCurrencies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = currenciesTable.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath) as! CurrencyTableViewCell
        
        cell.currencyShort.text = filterdCurrencies?[indexPath.row].short
        cell.currencyFullTerm.text = filterdCurrencies?[indexPath.row].full
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: filterdCurrencies?[indexPath.row].short, message: "App currency will be changed to \(filterdCurrencies?[indexPath.row].short ?? "")", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "change", style: .destructive, handler: { action in
            self.selectedCurrency.text = self.filterdCurrencies?[indexPath.row].short
            // Chang app currency
        }))
        alert.addAction(UIAlertAction(title: "cancel", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        currenciesTable.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filterdCurrencies = viewModel?.allCurrencies
            } else {
                filterdCurrencies = viewModel?.allCurrencies?.filter { $0.full.lowercased().contains(searchText.lowercased())
                    || $0.short.lowercased().contains(searchText.lowercased())
                }
            }
        
        currenciesTable.reloadData()
    }

}

