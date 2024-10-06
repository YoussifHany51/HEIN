//
//  SignUpViewController.swift
//  HEIN
//
//  Created by Youssif Hany on 04/09/2024.
//

import UIKit
import FirebaseAuth
import Firebase
import GoogleSignIn

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var signUpOutlet: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    private var activityIndicator: UIActivityIndicatorView?
    
    
    var viewModel = SignUpViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        configureUI()
        bindViewModel()
        showLoadingSpinner()
    }
    
    private func configureUI() {
        signUpOutlet.tintColor = .red
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textContentType = .password
        emailTextField.textContentType = .emailAddress
        
        // Initially hide the activity indicator
        activityIndicator?.isHidden = true
        activityIndicator?.hidesWhenStopped = true
    }
    
    private func bindViewModel() {
        viewModel.onError = { [weak self] errorMessage in
            self?.stopLoading()
            self?.showAlert(title: "Sorry", message: errorMessage)
        }
        
        viewModel.onSuccess = { [weak self] in
            self?.stopLoading()
            self?.showAlert(title: "Done✔️", message: "Your email has been successfully created.", isSuccess: true)
        }
        
        viewModel.onLoadingStateChange = { [weak self] isLoading in
            isLoading ? self?.startLoading() : self?.stopLoading()
        }
    }
    func showLoadingSpinner() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator?.center = view.center
        view.addSubview(activityIndicator!)
    }
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func alreadyHaveAccountButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func googleSignUpButton(_ sender: Any) {
        viewModel.googleSignUp(presentingViewController: self,name: nameTextField.text!,email: emailTextField.text!,password: passwordTextField.text!)
    }
    @IBAction func signUpButton(_ sender: Any) {
        if !viewModel.isInvalidTextFields(email: emailTextField.text!, password: passwordTextField.text!),nameTextField.text!.count > 0 {
            let name = nameTextField.text!
            let email = emailTextField.text!
            let password = passwordTextField.text!
            
            viewModel.signUp(name: name, email: email, password: password)
        } else {
            self.showAlert(title: "Sorry", message: "Please fill in all fields correctly.")
        }
        print("Sign Up Button Tapped")
        
    }
    func showAlert(title:String,message:String,isSuccess:Bool = false){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayButton = UIAlertAction(title: "ok", style: .default) { action in
            if isSuccess {
                self.dismiss(animated: true, completion: nil)
            }
        }
        alert.addAction(okayButton)
        self.present(alert, animated: true)
    }
    private func startLoading() {
        activityIndicator?.isHidden = false
        activityIndicator?.startAnimating()
        signUpOutlet.isEnabled = false
    }
    
    private func stopLoading() {
        activityIndicator?.stopAnimating()
        signUpOutlet.isEnabled = true
    }  
}
