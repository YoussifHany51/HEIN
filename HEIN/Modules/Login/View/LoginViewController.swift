//
//  ViewController.swift
//  HEIN
//
//  Created by Youssif Hany on 03/09/2024.
//

import UIKit
import FirebaseAuth
import Firebase
import GoogleSignIn
import FirebaseCore
class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButtonOutlet: UIButton!
    private var activityIndicator: UIActivityIndicatorView?
    var viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setupUI()
        bindViewModel()
        showLoadingSpinner()
    }
    
    private func setupUI() {
        loginButtonOutlet.tintColor = .red
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textContentType = .password
        emailTextField.textContentType = .emailAddress
        activityIndicator?.isHidden = true
    }
    
    private func bindViewModel() {
        viewModel.showLoading = { [weak self] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self?.activityIndicator?.startAnimating()
                    self?.activityIndicator?.isHidden = false
                } else {
                    self?.activityIndicator?.stopAnimating()
                    self?.activityIndicator?.isHidden = true
                }
            }
        }
        
        viewModel.showAlert = { [weak self] message in
            DispatchQueue.main.async {
                self?.showAlert(message: message)
            }
        }
        
        viewModel.navigateToMaster = { [weak self] in
            DispatchQueue.main.async {
                let storyBoard = UIStoryboard(name: "MasterStoryBoard", bundle: nil)
                let master = storyBoard.instantiateViewController(identifier: "TabBarController")
                // Replace the root view controller
                if let window = UIApplication.shared.windows.first {
                    window.rootViewController = master
                    window.makeKeyAndVisible()
                }
                //self?.present(master, animated: true)
            }
        }
    }
    func showLoadingSpinner() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator?.center = view.center
        view.addSubview(activityIndicator!)
    }
    
    @IBAction func skipButton(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "MasterStoryBoard", bundle: nil)
        let master = storyBoard.instantiateViewController(identifier: "TabBarController")
        //navigationController?.pushViewController(master, animated: true)

        // Replace the root view controller
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = master
            window.makeKeyAndVisible()
        }
        
        //self.present(master, animated: true)
    }
    

    @IBAction func dontHaveAccount(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController")
        present(vc!, animated: true)
    }
    @IBAction func loginButton(_ sender: Any) {
        if !viewModel.isInvalidTextFields(email: emailTextField.text!, password: passwordTextField.text!) {
            
            guard let email = emailTextField.text, let password = passwordTextField.text else { return }
            viewModel.login(email: email, password: password)
        } else {
            self.showAlert(message: "Please fill in all fields correctly.")
        }
    }
    
    @IBAction func googleSignInButton(_ sender: Any) {
        viewModel.googleSignIn(with: self)
    }
    func showAlert(message:String){
        let alert = UIAlertController(title: "Error ⚠️", message: message, preferredStyle: .alert)
        let okayButton = UIAlertAction(title: "Okay", style: .default)
        alert.addAction(okayButton)
        self.present(alert, animated: true)
    }
}

