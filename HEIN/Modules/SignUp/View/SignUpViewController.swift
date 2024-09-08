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
     if let savedString = defaults.string(forKey: "Auth.auth().currentUser!.uid") {
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
                    if let error = error as NSError? {
                        let authError = AuthErrorCode(rawValue: error.code)
                        switch authError {
                        case .userNotFound:
                            // If the user is not found, proceed with creating a new user
                            self?.createNewUser(email: email, password: password)
                            let defaults = UserDefaults.standard
                            defaults.set(self?.nameTextField.text!, forKey: Auth.auth().currentUser!.uid)
                        case .wrongPassword:
                            // If the email exists but the password is wrong, notify the user
                            self?.showAlert(message: "This email is already registered. Please log in.")
                            print("Email already in use.")
                        default:
                            // Handle other errors, if any
                            self?.showAlert(message: "Error: \(error.localizedDescription)")
                            print("Error: \(error.localizedDescription)")
                        }
                    } else {
                        // User exists and successfully logged in (though unlikely in this context)
                        self?.showAlert(message: "This email is already registered. Please log in.")
                        print("User already exists and is logged in.")
                    }
                }
            } else {
                self.showAlert(message: "Please fill in all fields correctly.")
            }
            print("Sign Up Button Tapped")
    }
    func showAlert(message:String){
        let alert = UIAlertController(title: "Error ⚠️", message: message, preferredStyle: .alert)
        let okayButton = UIAlertAction(title: "Okay", style: .default)
        alert.addAction(okayButton)
        self.present(alert, animated: true)
    }
    // Function to create a new user
    func createNewUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error as NSError? {
                let authError = AuthErrorCode(rawValue: error.code)
                switch authError {
                case .emailAlreadyInUse:
                    self?.showAlert(message: "This email is already in use. Please try logging in.")
                    print("Email already in use.")
                default:
                    self?.showAlert(message: "Error: \(error.localizedDescription)")
                    print("Error: \(error.localizedDescription)")
                }
            } else {
                // Successfully created a new user, navigate to the master view controller
                let master = self?.storyboard?.instantiateViewController(withIdentifier: "master")
                self?.navigationController?.pushViewController(master!, animated: true)
                print("User successfully created and logged in.")
            }
        }
    }
}
