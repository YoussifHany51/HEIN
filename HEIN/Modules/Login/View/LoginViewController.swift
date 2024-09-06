//
//  ViewController.swift
//  HEIN
//
//  Created by Youssif Hany on 03/09/2024.
//

import UIKit
import FirebaseAuth
import Firebase
class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButtonOutlet: UIButton!
    var viewModel = LoginViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loginButtonOutlet.tintColor = .red
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textContentType = .password
        emailTextField.textContentType = .emailAddress
    }

    @IBAction func DoNotHaveAccountButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func loginButton(_ sender: Any) {
        if viewModel.isInvalidTextFields(email: emailTextField.text!, password: passwordTextField.text!){
            //Reachability
            
            FirebaseAuth.Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) {[weak self] result, error in

                FirebaseAuth.Auth.auth().createUser(withEmail: self!.emailTextField.text!, password: self!.passwordTextField.text!) {[weak self] result, error in
                    let master = self?.storyboard?.instantiateViewController(withIdentifier: "master")
                    self?.navigationController?.pushViewController(master!, animated: true)
                    print("Logged in Success")
                }
            }
        }else{
            showAlert()
            print("Logged in Failed in TextFields")
        }
    }
    
    @IBAction func googleSignInButton(_ sender: Any) {
        
    }
    func showAlert(){
        let alert = UIAlertController(title: "Error", message: "Invalid Text Fields", preferredStyle: .alert)
        let okayButton = UIAlertAction(title: "Okay", style: .default)
        alert.addAction(okayButton)
        self.present(alert, animated: true)
    }
}

