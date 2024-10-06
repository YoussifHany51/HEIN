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
    
    @IBAction func searchButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SearchButtonSB", bundle: nil)
        let seearcchVC = storyboard.instantiateViewController(withIdentifier: "SearchButtonViewController") as! SearchButtonViewController
       
        self.present(seearcchVC, animated: true)
    }
    @IBAction func goToLogin(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let master = storyBoard.instantiateViewController(identifier: "LoginViewController")
        //self.present(master, animated: true)
        
        // Replace the root view controller
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = master
            window.makeKeyAndVisible()
        }
    }

}
