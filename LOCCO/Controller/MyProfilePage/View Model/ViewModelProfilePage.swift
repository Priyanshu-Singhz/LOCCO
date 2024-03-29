//
//  ViewModelProfilePage.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 16/02/24.
//


import Foundation
import UIKit
import MaterialComponents
struct ModelUserProfile {
    var email:String?
    var newPassword: String?
    var oldPassword: String?
    var name:String?
}
class ViewModelProfilePage{
    //MARK: - Properties
    var arraySectionData:[SectionModel] = []
    var dictValues:[String:Any] = [:]
    var passwordProgressChanged:((Float) -> ())?
    var userProfile:ModelUserProfile = ModelUserProfile()
    ///Store error for password if any.
    var nameError:String? = nil
    ///Store error for password if any.
    var newPasswordError:String? = nil
    ///Store error for password if any.
    var oldPasswordError:String? = nil
    ///Store error for e,ail if any.
    var emailError:String? = nil
    //Init Method
    init(){
        createSectionData()
    }
    // Create the SectionData
      func createSectionData(){
        arraySectionData.removeAll()
        //Header Model
        arraySectionData.append(SectionModel(identifier: "Edit Profile",rows: [
            Rowmodel(title: "profile_page_title", Identifier: "Edit Profile",type: "Edit Profile")
        ]))
        // Section 1
        arraySectionData.append(SectionModel(identifier: "Textfields",rows: [
            Rowmodel(title: "", Identifier: TextFieldIdetifier.name.rawValue,placeholder:  "e-mail_registration_name-field", type: "textfield"),
            Rowmodel(title: "", Identifier: TextFieldIdetifier.email.rawValue,placeholder: "e-mail-field", type: "textfield"),
        ]))
        // Section 2
        arraySectionData.append(SectionModel(identifier: "RadioButton",rows: [
            Rowmodel(title: "Keep me in the loop about new routes & other updates via email.", Identifier: "radioButton",type: "radioButton")
        ]))
        // Section 3
        arraySectionData.append(SectionModel(identifier: "Sections",rows: [
            Rowmodel(title: "profile_page_navigation", Identifier: "Manage account", type: "Manage account",isShowSeparatorLine: false),
            Rowmodel(title: "Language", Identifier: "Language",trailingText: AppLaunguage.shared.currentLanguageName, icon: UIImage(named: "ic_globe"), type: "Manage account",isShowSeparatorLine: true,isTralingText: true),
            Rowmodel(title: "profile_page_navigation-password", Identifier: "Change password", icon: UIImage(named: "Lock"), type: "Manage account", isShowNextButton: true,isShowSeparatorLine: true),
            Rowmodel(title: "profile_page_delete_account-title", Identifier: "Delete account",icon: UIImage(named: "Close Circle"),type: "Manage account", isShowNextButton: true,isShowSeparatorLine: true),
            Rowmodel(title: "profile_page_bottom-button", Identifier: "Logout",icon: UIImage(named: "Logout"),type: "Manage account"),
        ]))
        
        self.dictValues[TextFieldIdetifier.name.rawValue] = "john Deo"
        self.dictValues[TextFieldIdetifier.email.rawValue] = "example@abc.com"
        self.dictValues[TextFieldIdetifier.password.rawValue] = "123456789"
        self.dictValues["updates"] = false
    }
    // Create the SectionData
    func createLanguageData() -> [SectionModel]{
        arraySectionData.removeAll()
        arraySectionData.append(SectionModel(identifier: "Sections",rows: [
            Rowmodel(title: "English", Identifier: "en", type: "Language",isShowNextButton: true, isShowSeparatorLine: true),
            Rowmodel(title: "German", Identifier: "de" ,type: "Language",isShowNextButton: true,isShowSeparatorLine: true),
            Rowmodel(title: "Portuguese", Identifier: "pt",type: "Language", isShowNextButton: true,isShowSeparatorLine: false),
        ]))
        return arraySectionData
                                             
    }

    func textFieldValidations(_ profileCell:ProfileTextFieldTblViewCell){
        if let identifier = profileCell.customTextField.accessibilityIdentifier {
            switch identifier {
            case TextFieldIdetifier.name.rawValue:
                if let nameError = nameError {
                    profileCell.customTextField.leadingAssistiveLabel.text = nameError
                }else{
                    profileCell.customTextField.leadingAssistiveLabel.text = nil
                }
            default:
                break
            }
        }
    }
    //MARK: - Helper
    /// Validate inputs and return true if has any error otherwse false
    func validateEmail() -> Bool  {
        var hasError = false
        let name = dictValues[TextFieldIdetifier.name.rawValue] as? String
        if SMValidator.isEmptyString(name) {
            nameError = "registration-validation-message-name".translated
            hasError = true
        }
       return hasError
    }
    func validatePasswords() -> Bool{
        var hasError = false
        if SMValidator.isEmptyString(userProfile.newPassword) {
            newPasswordError = "registration-validation-message-password".translated
            hasError = true
        } else if userProfile.newPassword!.count < SMValidator.minPasswordLimit {
            newPasswordError = "e-mail_registration_prerequisites".translated
            hasError = true
        }
        if SMValidator.isEmptyString(userProfile.oldPassword) {
            oldPasswordError = "registration-validation-message-password".translated
            hasError = true
        }
        return hasError
    }
    
    func resetErrors() {
        emailError = nil
        nameError = nil
    }
    /// execute when textfield editing changed
    @objc func textFieldTextChanged(_ textfield:MDCOutlinedTextField) {
        //Reset error messages
        newPasswordError = nil
        oldPasswordError = nil
        textfield.leadingAssistiveLabel.text = nil
        //New Password
        if textfield.accessibilityIdentifier == TextFieldIdetifier.newPassword.rawValue {
            userProfile.newPassword = textfield.text
            //Notify to  related view for password changes
            let passwordStrength = SMValidator.progress(forPassword: textfield.text)
            passwordProgressChanged?(passwordStrength)
        }
        //Old Password
        else if textfield.accessibilityIdentifier == TextFieldIdetifier.password.rawValue {
            userProfile.oldPassword = textfield.text
        }
    }
}
