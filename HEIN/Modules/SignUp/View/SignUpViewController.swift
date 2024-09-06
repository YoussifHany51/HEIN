//
//  SignUpViewController.swift
//  HEIN
//
//  Created by Youssif Hany on 04/09/2024.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var signUpOutlet: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        signUpOutlet.tintColor = .red
    }
    
    @IBAction func alreadyHaveAccountButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func signUpButton(_ sender: Any) {
        print("Sign Up Button Tapped")
    }
}
