//
//  ReviewsViewController.swift
//  HEIN
//
//  Created by Youssif Hany on 17/09/2024.
//

import UIKit

class ReviewsViewController: UIViewController {

    @IBOutlet weak var reviewsTableView: UITableView!
    
    @IBOutlet weak var reviewsCounter: UILabel!
    
    var viewModel = ReviewsViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleLabel = UILabel()
        titleLabel.text = "Rating&Reviews"
            titleLabel.textAlignment = .left
            titleLabel.font = UIFont.boldSystemFont(ofSize: 25)
            titleLabel.textColor = .black
            self.view.addSubview(titleLabel)

            // Set constraints for the title label
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16), // Align to the left with padding
                titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10), // Position below the status bar
                titleLabel.heightAnchor.constraint(equalToConstant: 40), // Set a fixed height
                titleLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 200) // Optional: Set a max width
            ])
        
        reviewsTableView.dataSource = self
        reviewsTableView.delegate = self
        let reviewsCellNib = UINib(nibName: "ReviewsTableViewCell", bundle: nil)
        reviewsTableView.register(reviewsCellNib, forCellReuseIdentifier: "reviewCell")
        reviewsCounter.text =  "\(viewModel.reviews.count) reviews"
    }

}
extension ReviewsViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as! ReviewsTableViewCell
        cell.name.text = viewModel.reviews[indexPath.row].customerName
        cell.decription.text = viewModel.reviews[indexPath.row].message
        cell.decription.sizeToFit()
        cell.dateCreated.text = viewModel.reviews[indexPath.row].createdAt
        cell.rating.text = String(viewModel.reviews[indexPath.row].rating)
        cell.userImage.image = UIImage(named: viewModel.reviews[indexPath.row].customerImage)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}
