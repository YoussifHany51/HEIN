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
    var viewModel = LoginViewModel()
    var networkHandler:NetworkManager? = NetworkManager()
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
                    case .userNotFound:
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
                self?.getCustomers()
                
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
    
    func getCustomers(){
        networkHandler?.fetch(url: APIHandler.urlForGetting(.customers), type: AllCustomers.self, complitionHandler: { allCustomers in
            guard let allCustomer = allCustomers else { return }
            if let customer = self.filterCustomer(customers: allCustomer.customers!) {
                if customer.id != nil {
                    let defaults = UserDefaults.standard
                    defaults.set(customer.id, forKey: "User_id")
                    defaults.set(customer.first_name, forKey: "User_name")
                    self.getDraftOrders(customerId: customer.id!)
                }
            }else{
                self.postCustomer()
            }
        })
    }
    
    func getDraftOrders(customerId : Int){
        networkHandler?.fetch(url: APIHandler.urlForGetting(.draftOrders), type: DraftOrders.self, complitionHandler: { draftOrders in
            guard let draftOrders = draftOrders else { return }
            var draftOrder : DraftOrder
            let filterd = draftOrders.draftOrders.filter { draftOrder in
                draftOrder.customer?.id == customerId
            }
            draftOrder = filterd.first!
            let defaults = UserDefaults.standard
            defaults.set(draftOrder.id, forKey: "DraftOrder_Id")
            print(draftOrder.id)
            print("Logged in Successfully")
            let master = self.storyboard?.instantiateViewController(withIdentifier: "master")
            self.navigationController?.pushViewController(master!, animated: true)
            print(defaults.string(forKey: "DraftOrder_Id")!)
            print(defaults.string(forKey: "User_name")!)
            print(defaults.string(forKey: "User_id")!)
              
        })
    }
    
    func filterCustomer(customers:[CustomerModel]) -> CustomerModel? {
        var customer : CustomerModel?
        let customers = customers.filter { customerModel in
            customerModel.note == Auth.auth().currentUser?.uid
        }
        customer = customers.first
        return customer
    }
    func postCustomer(){
        let defaults = UserDefaults.standard
        guard let name = defaults.string(forKey: Auth.auth().currentUser!.uid) else { return }
        let email = Auth.auth().currentUser?.email
        let userID = Auth.auth().currentUser?.uid
        networkHandler?.postWithResponse(url: APIHandler.urlForGetting(.customers), type: Customer.self, parameters: ["customer":["first_name":name,"email": email,"note": userID]], completion: { customer in
            guard let customer = customer else {
                print("Error Posting Customer")
                return
            }
            self.postDraftOrder(id: customer.customer.id!)
            let defaults = UserDefaults.standard
            defaults.set(customer.customer.id, forKey: "User_id")
            defaults.set(customer.customer.first_name, forKey: "User_name")
            
            print("POST Customer successfully")
        })
    }
    
    func postDraftOrder(id:Int){
        let dummyLineItem: [String: Any] = ["title": "dummy", "quantity": 1, "price": "0.0", "properties":[]]
        networkHandler?.postWithResponse(url: APIHandler.urlForGetting(.draftOrders), type: DraftOrderContainer.self, parameters: ["draft_order":["line_items":  [dummyLineItem], "customer":["id":id],"use_customer_default_address":true]], completion: { draftOrderContainer in
            guard let draftOrderContainer = draftOrderContainer else {
                print("Faild draftOrderContainer")
                return
            }
            let defaults = UserDefaults.standard
            defaults.set(draftOrderContainer.draftOrder.id, forKey: "DraftOrder_Id")
            print(draftOrderContainer.draftOrder.id)
            let master = self.storyboard?.instantiateViewController(withIdentifier: "master")
            self.navigationController?.pushViewController(master!, animated: true)
            print(defaults.string(forKey: "DraftOrder_Id")!)
            print(defaults.string(forKey: "User_name")!)
            print(defaults.string(forKey: "User_id")!)
        })
    }
}

