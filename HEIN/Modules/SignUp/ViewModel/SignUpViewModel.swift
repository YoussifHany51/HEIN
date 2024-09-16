//
//  SignUpViewModel.swift
//  HEIN
//
//  Created by Youssif Hany on 08/09/2024.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

class SignUpViewModel{
    func isValidEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    func validatePassword(password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
    func isInvalidTextFields(email:String,password:String) -> Bool{
        if isValidEmail(email: email) && validatePassword(password: password){
            return true
        }else{
            return false
        }
    }
    var onError: ((String) -> Void)?
    var onSuccess: (() -> Void)?
    var onLoadingStateChange: ((Bool) -> Void)?
    
    func signUp(name: String, email: String, password: String) {
        guard validateInput(name: name, email: email, password: password) else {
            onError?("Please fill in all fields correctly.")
            return
        }
        
        onLoadingStateChange?(true)
        
        // Check if the user already exists
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if error != nil {
                // If the email does not exist, proceed to create a new account
                self?.createNewUser(name: name, email: email, password: password)
            } else {
                self?.onLoadingStateChange?(false) 
                self?.onError?("Email is already associated with an existing account.")
            }
        }
    }
    
    private func createNewUser(name: String, email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            self?.onLoadingStateChange?(false)
            
            if let error = error {
                self?.onError?("Error: \(error.localizedDescription)")
            } else {
                self?.storeUserNameInUserDefaults(name: name)
                self?.onSuccess?()
            }
        }
    }
    
    private func storeUserNameInUserDefaults(name: String) {
        if let uid = Auth.auth().currentUser?.uid {
            let defaults = UserDefaults.standard
            defaults.set(name, forKey: uid)
        }
    }
    
    func googleSignUp(presentingViewController: UIViewController,name:String,email:String,password:String) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            onError?("Google Client ID not found.")
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        onLoadingStateChange?(true) // Start loading
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { [weak self] result, error in
            self?.onLoadingStateChange?(false) // Stop loading
            
            if let error = error {
                self?.onError?("Google Sign-In failed: \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                self?.onError?("Google Sign-In failed to retrieve user.")
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if error != nil {
                    // If the email does not exist, proceed to create a new account
                    self?.createNewUser(name: name, email: email, password: password)
                } else {
                    self?.onLoadingStateChange?(false)
                    self?.onError?("Email is already associated with an existing account.")
                }
            }
        }
    }
    
    private func validateInput(name: String, email: String, password: String) -> Bool {
        return !name.isEmpty && !email.isEmpty && !password.isEmpty
    }
    
}
