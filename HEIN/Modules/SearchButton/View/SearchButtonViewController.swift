//
//  SearchButtonViewController.swift
//  HEIN
//
//  Created by Youssif Hany on 08/09/2024.
//

import UIKit
import Combine

class SearchButtonViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var textField: UITextField!
    
    var data = [Product]()
    var filteredData = [Product]()
    var filtered = false
    var searchVM:SearchButtonViewModel?
    var network = ReachabilityManager()
    private var searchCancellable: AnyCancellable?
    private var loadingSpinner: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchVM = SearchButtonViewModel()
        self.hideKeyboardWhenTappedAround()
        tableView.delegate = self
        tableView.dataSource = self
        textField.delegate = self
        textField.placeholder = "Search..  🔍"
        setupBindings()
        searchVM?.loadData()
        setupSearchDebounce()
    }
    
    func setupBindings() {
        searchVM?.bindProductsToViewController = { [weak self] in
            guard let self = self else { return }
            self.hideLoadingSpinner()
            self.setupData()
        }
        showLoadingSpinner()
    }
    
    func setupData() {
        network.checkNetworkReachability {[weak self] isReachable in
            if isReachable{
                guard let products = self?.searchVM?.result?.products else { return }
                self?.data = products
                self?.tableView.reloadData()
            }else{
                let alert = UIAlertController(title: "Ops.. ☹️", message: "NO Internet Connection", preferredStyle: .alert)
                let okayButton = UIAlertAction(title: "Got it 👍", style: .default)
                alert.addAction(okayButton)
                self?.present(alert, animated: true)
            }
        }
           
    }
    
    func setupSearchDebounce() {
            searchCancellable = NotificationCenter.default
                .publisher(for: UITextField.textDidChangeNotification, object: textField)
                .compactMap { ($0.object as? UITextField)?.text }
                .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
                .sink { [weak self] searchText in
                    self?.filteredText(searchText)
                }
        }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text{
            filteredText(text+string)
        }
        return true
    }
    
    func filteredText(_ query:String){
        filteredData.removeAll()
        for string in data {
            if string.title.lowercased().starts(with: query.lowercased()){
                filteredData.append(string)
            }
        }
        tableView.reloadData()
        filtered = true
    }
    
    func showLoadingSpinner() {
            loadingSpinner = UIActivityIndicatorView(style: .large)
            loadingSpinner?.center = view.center
            loadingSpinner?.startAnimating()
            view.addSubview(loadingSpinner!)
        }
        
        func hideLoadingSpinner() {
            loadingSpinner?.stopAnimating()
            loadingSpinner?.removeFromSuperview()
            loadingSpinner = nil
        } 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !filteredData.isEmpty{
            return filteredData.count
        }
        return filtered ? 0 : data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell",for: indexPath)
        if !filteredData.isEmpty {
            cell.textLabel?.text = filteredData[indexPath.row].title
        }
        else{
            cell.textLabel?.text = data[indexPath.row].title
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "ProductsInfoSB", bundle: nil)
        let productInfovc = storyboard.instantiateViewController(withIdentifier: "ProductsInfoViewController") as! ProductsInfoViewController
        if !filteredData.isEmpty{
            productInfovc.product = filteredData[indexPath.row]
        }else{
            productInfovc.product = data[indexPath.row]
        }
        self.present(productInfovc, animated: true)
    }

}
