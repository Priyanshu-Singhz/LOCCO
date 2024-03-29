//
//  ViewModelRegister.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 14/02/24.
//

import Foundation
import UIKit
import MaterialComponents
typealias responseRegister = ((_ result:Any?, _ isSucess:Bool, _ message: String?) -> ())
typealias responseGeneral = ((_ result:BaseModel?, _ isSucess:Bool, _ message: String?) -> ())

class ViewModelRegister {
    var credentials:ModelLogin = ModelLogin()
    
    var passwordProgressChanged:((Float) -> ())?
    
    ///Store error for password if any.
    var nameError:String? = nil
    ///Store error for password if any.
    var passwordError:String? = nil
    ///Store error for e,ail if any.
    var emailError:String? = nil
    
    
    //MARK: - Helper
    /// Validate inputs and return true if has any error otherwse false
    func validate() -> Bool  {
        var hasError = false
        
        if SMValidator.isEmptyString(credentials.name) {
            nameError = "registration-validation-message-name".translated
            hasError = true
        }
        
        if let error = SMValidator.validate(email: credentials.email) {
            emailError = error
            hasError = true
        }
        
        if SMValidator.isEmptyString(credentials.password) {
            passwordError = "registration-validation-message-password".translated
            hasError = true
        } else if credentials.password.count < SMValidator.minPasswordLimit {
            passwordError = "e-mail_registration_prerequisites".translated
            hasError = true
        }
        
        return hasError
    }
    
    /// execute when textfield editing changed
    @objc func textFieldTextChanged(_ textfield:MDCOutlinedTextField) {
        //Reset error messages
        emailError = nil
        passwordError = nil
        nameError = nil
        textfield.leadingAssistiveLabel.text = nil
        //Save value
        if textfield.accessibilityIdentifier == TextFieldIdetifier.email.rawValue {
            credentials.email = textfield.text ?? ""
        } else if textfield.accessibilityIdentifier == TextFieldIdetifier.password.rawValue {
            credentials.password = textfield.text ?? ""
            //Notify to  related view for password changes
            let passwordStrength = SMValidator.progress(forPassword: textfield.text)
            passwordProgressChanged?(passwordStrength)
        } else if textfield.accessibilityIdentifier == TextFieldIdetifier.name.rawValue {
            credentials.name = textfield.text ?? ""
        }
        
    }
    /// Set status of Update
    func setUpdateStatus(_ status:Bool) {
        credentials.isUpdate = status
    }
    
    //MARK: - API
    /// Register user to  server
    func registerUser(completion:@escaping responseRegister) {
        var parameter:[String:Any] = [:]
        parameter["email"] = credentials.email
        parameter["password"] = credentials.password
        parameter["firstName"] = credentials.name
        parameter["lastName"] = credentials.email
        parameter["keepUpdated"] = credentials.isUpdate
        
        SMAPIManager.shared().request(type: .register, params: parameter) { responseData, statusCode, error in
            let decodedResult = SMAPIManager.decodeError(code: statusCode, data: responseData)
            completion(responseData, decodedResult.success, decodedResult.message)
        }
    }
    
    /// Verify code with server
    static func confirmCode(email:String, code:String, completion:@escaping responseRegister) {
        var parameter:[String:Any] = [:]
        parameter["email"] = email
        parameter["code"] = code
        SMAPIManager.shared().request(type: .confirmRegister, params: parameter) { responseData, statusCode, error in
            let decodedResult = SMAPIManager.decodeError(code: statusCode, data: responseData)
            completion(responseData, decodedResult.success, decodedResult.message)
        }
    }
    
    /// send code on given email
    static func resendCode(email:String, completion:@escaping responseGeneral) {
        var parameter:[String:Any] = [:]
        parameter["email"] = email
        SMAPIManager.shared().request(type: .resendCode, params: parameter) { responseData, statusCode, error in
            let decodedResult = SMAPIManager.decodeError(code: statusCode, data: responseData)
            var resultModel:BaseModel? = nil
            if let resData = responseData {
                do {
                    resultModel = try JSONDecoder().decode(BaseModel.self, from: resData)
                    resultModel?.statusCode = statusCode
                } catch {
                    appPrint("[ViewModelLogin] loginUser decode error: ", error)
                }
            }
            
            completion(resultModel, decodedResult.success, decodedResult.message)
        }
    }
}
