//
//  GuestMeViewController.swift
//  HEIN
//
//  Created by Marco on 2024-09-16.
//

import UIKit

class GuestMeViewController: UIViewController {

    @IBOutlet weak var guestMeNavigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.isHidden = true
        
        guestMeNavigationBar.shadowImage = UIImage()
        guestMeNavigationBar.setBackgroundImage(UIImage(), for: .default)
        guestMeNavigationBar.isTranslucent = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ReachabilityManager.checkNetworkReachability { isReachable in
            if !isReachable {
                ReachabilityManager.showConnectionAlert(view: self)
            }
        }
    }
    
    @IBAction func SearchButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SearchButtonSB", bundle: nil)
        let seearcchVC = storyboard.instantiateViewController(withIdentifier: "SearchButtonViewController") as! SearchButtonViewController
        self.present(seearcchVC, animated: true)
    }
    @IBAction func goToLogin(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let master = storyBoard.instantiateViewController(identifier: "LoginViewController")
        self.present(master, animated: true)
    }

}
