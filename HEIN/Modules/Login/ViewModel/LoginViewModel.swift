//
//  LoginViewModel.swift
//  HEIN
//
//  Created by Youssif Hany on 06/09/2024.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

class LoginViewModel{
    
    var networkHandler: NetworkManager?
    var showLoading: ((Bool) -> Void)?
    var showAlert: ((String) -> Void)?
    var navigateToMaster: (() -> Void)?
    
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
    
    
    init(networkHandler: NetworkManager = NetworkManager()) {
        self.networkHandler = networkHandler
    }
    
    func login(email: String, password: String) {
        showLoading?(true)
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            self?.showLoading?(false)
            if let error = error as NSError? {
                self?.handleFirebaseAuthError(error: error)
                return
            }
            // Success, fetch customer data
            self?.getCustomers()
        }
    }
    
    func googleSignIn(with viewController: UIViewController) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { result, error in
            guard let user = result?.user, let idToken = user.idToken?.tokenString else {
                self.showAlert?("Google Sign In failed.")
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { [weak self] result, error in
                if let error = error as NSError? {
                    self?.handleFirebaseAuthError(error: error)
                    return
                }
                // Success, fetch customer data
                self?.getCustomers()
            }
        }
    }
    
    private func handleFirebaseAuthError(error: NSError) {
        var message = "Unknown error occurred"
        switch AuthErrorCode(rawValue: error.code) {
        case .wrongPassword:
            message = "Wrong Email or Password❗️"
        case .userNotFound:
            message = "Please Sign Up First"
        case .networkError:
            message = "Network Connection Failed❗️ 😞"
        default:
            message = "Error: \(error.localizedDescription)"
        }
        showAlert?(message)
    }
    
    func getCustomers() {
        networkHandler?.fetch(url: APIHandler.urlForGetting(.customers), type: AllCustomers.self, complitionHandler: { [weak self] allCustomers in
            guard let allCustomer = allCustomers else { return }
            if let customer = self?.filterCustomer(customers: allCustomer.customers!) {
                if let customerId = customer.id {
                    UserDefaults.standard.set(customerId, forKey: "User_id")
                    UserDefaults.standard.set(customer.first_name, forKey: "User_name")
                    self?.getDraftOrders(customerId: customerId)
                }
            } else {
                self?.postCustomer()
            }
        })
    }
    
    private func filterCustomer(customers: [CustomerModel]) -> CustomerModel? {
        return customers.first { $0.note == Auth.auth().currentUser?.uid }
    }
    
    private func getDraftOrders(customerId: Int) {
        networkHandler?.fetch(url: APIHandler.urlForGetting(.draftOrders), type: DraftOrders.self, complitionHandler: { draftOrders in
            guard let draftOrders = draftOrders else { return }
            let filtered = draftOrders.draftOrders.first { $0.customer?.id == customerId }
            if let draftOrder = filtered {
                UserDefaults.standard.set(draftOrder.id, forKey: "DraftOrder_Id")
                self.navigateToMaster?()
            }
        })
    }
    
    private func postCustomer() {
        guard let user = Auth.auth().currentUser else { return }
        let name = user.displayName ?? ""
        let email = user.email
        let userID = user.uid
        
        let parameters: [String: Any] = ["customer": ["first_name": name, "email": email ?? "", "note": userID]]
        
        networkHandler?.postWithResponse(url: APIHandler.urlForGetting(.customers), type: Customer.self, parameters: parameters) { customer in
            guard let customer = customer else { return }
            UserDefaults.standard.set(customer.customer.id, forKey: "User_id")
            UserDefaults.standard.set(customer.customer.first_name, forKey: "User_name")
            self.postDraftOrder(id: customer.customer.id!)
        }
    }
    
    private func postDraftOrder(id: Int) {
        let dummyLineItem: [String: Any] = ["title": "dummy", "quantity": 1, "price": "0.0", "properties": []]
        let parameters: [String: Any] = ["draft_order": ["line_items": [dummyLineItem], "customer": ["id": id], "use_customer_default_address": true]]
        
        networkHandler?.postWithResponse(url: APIHandler.urlForGetting(.draftOrders), type: DraftOrderContainer.self, parameters: parameters) { draftOrderContainer in
            guard let draftOrderContainer = draftOrderContainer else { return }
            UserDefaults.standard.set(draftOrderContainer.draftOrder.id, forKey: "DraftOrder_Id")
            self.navigateToMaster?()
        }
    }
}
