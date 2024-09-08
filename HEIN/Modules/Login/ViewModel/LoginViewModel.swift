//
//  LoginViewModel.swift
//  HEIN
//
//  Created by Youssif Hany on 06/09/2024.
//

import Foundation
class LoginViewModel{
    
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
}
