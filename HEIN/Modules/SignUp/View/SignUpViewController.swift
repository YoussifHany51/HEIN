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
    
    var viewModel = SignUpViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpOutlet.tintColor = .red
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textContentType = .password
        emailTextField.textContentType = .emailAddress
    }
    
    @IBAction func alreadyHaveAccountButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func googleSignUpButton(_ sender: Any) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in
          guard error == nil else {
              return
          }

          guard let user = result?.user,
            let idToken = user.idToken?.tokenString
          else {
              return
          }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: user.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { result, error in

              // At this point, our user is signed in
            }
        }
    }
    // To retrive Username 
    /*
     let defaults = UserDefaults.standard
     if let savedString = defaults.string(forKey: Auth.auth().currentUser!.uid) {
         print("Saved String: \(savedString)")
     } else {
         print("No string found for the key.")
     }
     */
    @IBAction func signUpButton(_ sender: Any) {
        if !viewModel.isInvalidTextFields(email: emailTextField.text!, password: passwordTextField.text!),nameTextField.text!.count > 0 {
                let email = emailTextField.text!
                let password = passwordTextField.text!
                
                // First attempt to sign in to check if the email already exists
                Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                    self?.createNewUser(email: email, password: password)
                }
            } else {
                self.showAlert(title: "Error ⚠️", message: "Please fill in all fields correctly.")
            }
            print("Sign Up Button Tapped")
        
    }
    func showAlert(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayButton = UIAlertAction(title: "Okay", style: .default)
        alert.addAction(okayButton)
        self.present(alert, animated: true)
    }
    // Function to create a new user
    private func createNewUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                // Handle any errors that occur during user creation
                self?.showAlert(title: "Error ⚠️", message: "Error: \(error.localizedDescription)")
                print("Error: \(error.localizedDescription)")
            } else {
                // Successfully created a new user
                self?.storeUserNameInUserDefaults()
                self?.showAlert(title: "Done 🥳💃", message: "User created successfully!")
                print("User created successfully!")
                // Navigate to the next screen or update the UI as needed
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    private func storeUserNameInUserDefaults() {
        if let uid = Auth.auth().currentUser?.uid {
            let defaults = UserDefaults.standard
            defaults.set(nameTextField.text!, forKey: uid)
        }
    }
}
