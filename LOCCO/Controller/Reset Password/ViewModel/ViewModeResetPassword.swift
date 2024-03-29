//
//  ViewModeResetPassword.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 16/02/24.
//

import Foundation
import MaterialComponents

class ViewModeResetPassword {
    var strPassword:String? = nil
    var strCode:String? = nil
    var email:String = ""
    var passwordProgressChanged:((Float) -> ())?
    
  
    ///Store error for password if any.
    var passwordError:String? = nil
    ///Store error for Code ,ail if any.
    var codeError:String? = nil
    
    
    //MARK: - Helper
    /// Validate inputs and return true if has any error otherwse false
    func validate() -> Bool  {
        var hasError = false
        if SMValidator.isEmptyString(strCode) {
            codeError = "reset_password_validation-message-code".translated
            hasError = true
        } else if strCode!.count < 6 {
            codeError = "reset_password_validation-message-code".translated
            hasError = true
        } 
        if SMValidator.isEmptyString(strPassword) {
            passwordError = "reset_password_validation-message-password".translated
            hasError = true
        } else if strPassword!.count < SMValidator.minPasswordLimit {
            passwordError = "e-mail_registration_prerequisites".translated
            hasError = true
        }
        
        return hasError
    }
    
    /// execute when textfield editing changed
    @objc func textFieldTextChanged(_ textfield:MDCOutlinedTextField) {
        //Reset error messages
        passwordError = nil
        textfield.leadingAssistiveLabel.text = nil
        //Save value
        if textfield.accessibilityIdentifier == TextFieldIdetifier.password.rawValue {
            strPassword = textfield.text
            //Notify to  related view for password changes
            let passwordStrength = SMValidator.progress(forPassword: textfield.text)
            passwordProgressChanged?(passwordStrength)
        }
    }
    
    //MARK: - API
    
    
    static func forgotPassword(email:String, completion:@escaping responseGeneral) {
        var parameter:[String:Any] = [:]
        parameter["email"] = email
        SMAPIManager.shared().request(type: .forgotPassword, params: parameter) { responseData, statusCode, error in
            let decodedResult = SMAPIManager.decodeError(code: statusCode, data: responseData)
            var resultModel:BaseModel? = nil
            if let resData = responseData {
                do {
                    resultModel = try JSONDecoder().decode(BaseModel.self, from: resData)
                    resultModel?.statusCode = statusCode
                } catch {
                    appPrint("[ViewModeResetPassword] forgotPassword decode error: ", error)
                }
            }
            completion(resultModel, decodedResult.success, decodedResult.message)
        }
    }
    
    
    /// confirm password with code and email
    func confirmNewPasword(completion:@escaping responseGeneral) {
        var parameter:[String:Any] = [:]
        parameter["email"] = email
        parameter["confirmationCode"] = strCode
        parameter["newPassword"] = strPassword!
        SMHud.animate()
        SMAPIManager.shared().request(type: .confirmForgotPassword, params: parameter) { responseData, statusCode, error in
            SMHud.dimiss()
            let decodedResult = SMAPIManager.decodeError(code: statusCode, data: responseData)
            var resultModel:BaseModel? = nil
            if let resData = responseData {
                do {
                    resultModel = try JSONDecoder().decode(BaseModel.self, from: resData)
                    resultModel?.statusCode = statusCode
                } catch {
                    appPrint("[ViewModeResetPassword] confirmNewPasword decode error: ", error)
                }
            }
            
            completion(resultModel, decodedResult.success, decodedResult.message)
        }
    }
}
