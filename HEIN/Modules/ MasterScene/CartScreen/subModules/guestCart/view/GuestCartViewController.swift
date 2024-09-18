//
//  GuestCartViewController.swift
//  HEIN
//
//  Created by Marco on 2024-09-16.
//

import UIKit

class GuestCartViewController: UIViewController {

    @IBOutlet weak var guestCartNavigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.isHidden = true
        
        guestCartNavigationBar.shadowImage = UIImage()
        guestCartNavigationBar.setBackgroundImage(UIImage(), for: .default)
        guestCartNavigationBar.isTranslucent = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ReachabilityManager.checkNetworkReachability { isReachable in
            if !isReachable {
                ReachabilityManager.showConnectionAlert(view: self)
            }
        }
    }
    
    @IBAction func goToLogin(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let master = storyBoard.instantiateViewController(identifier: "LoginViewController")
        self.present(master, animated: true)
    }

}
