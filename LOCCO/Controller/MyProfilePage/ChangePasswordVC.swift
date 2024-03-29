//
//  ChangePasswordVC.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 01/03/24.
//

import UIKit
import MaterialComponents

class ChangePasswordVC:UIViewController{
    @IBOutlet var navigationHeader: SMNavigationBar!
    @IBOutlet var newPasswordTxt: MDCOutlinedTextField!
    @IBOutlet var progressBar: SMProgressBar!
    @IBOutlet var changePasswordLbl: UILabel!
    @IBOutlet var oldPasswordTxt: MDCOutlinedTextField!
    @IBOutlet var btnSavePassword: UIButton!
    fileprivate var vmProfilePage = ViewModelProfilePage()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.progressBar.isHidden = false
        vmProfilePage.passwordProgressChanged = { progress in
//            let pwdCount = self.vmProfilePage.userProfile.newPassword?.count ?? 0
//            self.progressBar.isHidden = (pwdCount < SMValidator.minPasswordLimit)
            self.progressBar.currentProgress = progress
        }
    }
    func setupUI(){
        navigationHeader.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 32)
        navigationHeader.navigationTitle = "home_profile".translated.uppercased()
        navigationHeader.backButtonClicked = { sender in
            self.navigationController?.popViewController(animated: true)
        }
        btnSavePassword.setTitle("profile_page_edit_password-save-password".translated, for: .normal)
        changePasswordLbl.text = "profile_page_navigation-password".translated
        //Configure textfields
        newPasswordTxt.label.text = "reset_password_new_password-field".translated
        oldPasswordTxt.label.text = "profile_page_edit_password-old-password-input-field".translated
        setUpTextField(newPasswordTxt)
        setUpTextField(oldPasswordTxt)
        //Set Identifiers
        newPasswordTxt.accessibilityIdentifier = TextFieldIdetifier.newPassword.rawValue
        oldPasswordTxt.accessibilityIdentifier = TextFieldIdetifier.password.rawValue
        //Add Observers
        newPasswordTxt.addTextChanges(vmProfilePage, action: #selector(vmProfilePage.textFieldTextChanged(_:)))
        oldPasswordTxt.addTextChanges(vmProfilePage, action: #selector(vmProfilePage.textFieldTextChanged(_:)))
        progressBar.trackTintColor = .appWhite
    }
    func setUpTextField(_ textField:MDCOutlinedTextField){
        textField.isSecureTextEntry = true
        textField.themeWhiteFill(isPasswordColor: true)
        textField.enablePasswordToggle(.appSkyBlue)
    }
    @IBAction func savePasswordClicked(_ sender: UIButton) {
        if vmProfilePage.validatePasswords() {
            if let newPasswordError = vmProfilePage.newPasswordError{
                newPasswordTxt.leadingAssistiveLabel.text = newPasswordError
            }
            if let oldPasswordError = vmProfilePage.oldPasswordError {
                oldPasswordTxt.leadingAssistiveLabel.text = oldPasswordError
            }
        } else {
            print("Validation Success")
        }
    }
}
