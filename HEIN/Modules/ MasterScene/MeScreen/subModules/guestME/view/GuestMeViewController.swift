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
    
    @IBAction func goToLogin(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let master = storyBoard.instantiateViewController(identifier: "LoginViewController")
        self.present(master, animated: true)
    }

}
