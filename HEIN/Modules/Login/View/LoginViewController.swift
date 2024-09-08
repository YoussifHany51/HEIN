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
        if !viewModel.isInvalidTextFields(email: emailTextField.text!, password: passwordTextField.text!) {
            
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) {[weak self] authResult, error in
                guard error == nil else{
                    let error = error as NSError?
                    switch AuthErrorCode(rawValue: error!.code) {
                    case .wrongPassword:
                        self?.showAlert(message: "Wrong Email or Password❗️")
                        break
                    case .invalidUserToken: #warning("Check User NOT found")
                        self?.showAlert(message: "Please Sign Up First")
                        break
                    case .networkError:
                        self?.showAlert(message: "Network Connection Failed❗️ 😞")
                        break
                    default:
                        self?.showAlert(message: "Error: \(error!.localizedDescription)")
                        print("Error: \(error!.localizedDescription)")
                        break
                    }
                    return
                }
                // Successful sign-in, navigate to the master view controller
                let master = self?.storyboard?.instantiateViewController(withIdentifier: "master")
                self?.navigationController?.pushViewController(master!, animated: true)
                print("Logged in Successfully")
            }
        } else {
            self.showAlert(message: "Please fill in all fields correctly.")
        }
    }
    
    @IBAction func googleSignInButton(_ sender: Any) {
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
    func showAlert(message:String){
        let alert = UIAlertController(title: "Error ⚠️", message: message, preferredStyle: .alert)
        let okayButton = UIAlertAction(title: "Okay", style: .default)
        alert.addAction(okayButton)
        self.present(alert, animated: true)
    }
}

