//
//  ViewModelLogin.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 14/02/24.
//

import Foundation
import MaterialComponents

struct ModelLogin {
    var email:String = ""
    var password: String = ""
    var name:String?
    var isUpdate:Bool = true
    var givenName:String = ""
    var familyName:String = ""
    var socialID:String = ""
}
enum TextFieldIdetifier: String {
    case email = "email"
    case password = "password"
    case newPassword = "newPassword"
    case name = "name"
}

class ViewModelLogin {
    var credentials:ModelLogin = ModelLogin()
    ///Store error for password if any.
    var passwordError:String? = nil
    ///Store error for e,ail if any.
    var emailError:String? = nil
    
    
    //MARK: - Helper
    /// Validate inputs and return true if has any error otherwse false
    func validate() -> Bool  {
        var hasError = false
        if let error = SMValidator.validate(email: credentials.email) {
            emailError = error
            hasError = true
        }
        
        if SMValidator.isEmptyString(credentials.password){
            passwordError = "registration-validation-message-password".translated
            hasError = true
        }
        
        return hasError
    }
    
    /// execute when textfield editing changed
    @objc func textFieldTextChanged(_ textfield:MDCOutlinedTextField) {
        //Reset error messages
        emailError = nil
        passwordError = nil
        textfield.leadingAssistiveLabel.text = nil
        //Save value
        if textfield.accessibilityIdentifier == TextFieldIdetifier.email.rawValue {
            credentials.email = textfield.text ?? ""
        } else if textfield.accessibilityIdentifier == TextFieldIdetifier.password.rawValue {
            credentials.password = textfield.text ?? ""
        }
    }
    
    /// Login user to  server
    static func loginUser(credentials:ModelLogin, completion:@escaping ((_ result:ModelLoginResponse?, _ isSucess:Bool, _ message: String?) -> ())) {
        var parameter:[String:Any] = [:]
        parameter["email"] = credentials.email
        parameter["password"] = credentials.password
       
        SMAPIManager.shared().request(type: .login, params: parameter) { responseData, statusCode, error in
            let decodedResult = SMAPIManager.decodeError(code: statusCode, data: responseData)
            var loginResult:ModelLoginResponse? = ModelLoginResponse(statusCode: statusCode)
            if let resData = responseData {
                do {
                    loginResult = try JSONDecoder().decode(ModelLoginResponse.self, from: resData)
                    loginResult?.statusCode = statusCode
                } catch {
                    appPrint("[ViewModelLogin] loginUser decode error: ", error)
                }
            }
            
            completion(loginResult, decodedResult.success, decodedResult.message)
        }
    }
    
    /// Login with Google  to server
    static func googleAuth(credentials:ModelLogin, completion:@escaping ((_ result:ModelLoginResponse?, _ isSucess:Bool, _ message: String?) -> ())) {
        var parameter:[String:Any] = [:]
        parameter["googleAccessToken"] = credentials.socialID
        parameter["givenName"] = credentials.givenName
        parameter["familyName"] = credentials.familyName
        SMAPIManager.shared().request(type: .googleLogin, params: parameter) { responseData, statusCode, error in
            let decodedResult = SMAPIManager.decodeError(code: statusCode, data: responseData)
            var loginResult:ModelLoginResponse? = ModelLoginResponse(statusCode: statusCode)
            if let resData = responseData {
                do {
                    loginResult = try JSONDecoder().decode(ModelLoginResponse.self, from: resData)
                    loginResult?.statusCode = statusCode
                } catch {
                    appPrint("[ViewModelLogin] loginUser decode error: ", error)
                }
            }
            
            completion(loginResult, decodedResult.success, decodedResult.message)
        }
    }
    
    /// Login with Apple to  server
    static func appleAuth(credentials:ModelLogin, completion:@escaping ((_ result:ModelLoginResponse?, _ isSucess:Bool, _ message: String?) -> ())) {
        var parameter:[String:Any] = [:]
        parameter["appleIdToken"] = credentials.socialID
        parameter["givenName"] = credentials.givenName
        parameter["familyName"] = credentials.familyName
        SMAPIManager.shared().request(type: .appleLogin, params: parameter) { responseData, statusCode, error in
            let decodedResult = SMAPIManager.decodeError(code: statusCode, data: responseData)
            var loginResult:ModelLoginResponse? = ModelLoginResponse(statusCode: statusCode)
            if let resData = responseData {
                do {
                    loginResult = try JSONDecoder().decode(ModelLoginResponse.self, from: resData)
                    loginResult?.statusCode = statusCode
                } catch {
                    appPrint("[ViewModelLogin] loginUser decode error: ", error)
                }
            }
            
            completion(loginResult, decodedResult.success, decodedResult.message)
        }
    }
}
