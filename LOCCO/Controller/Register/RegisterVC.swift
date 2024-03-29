//
//  RegisterVC.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 14/02/24.
//

import UIKit
import MaterialComponents

class RegisterVC: UIViewController {
    @IBOutlet weak var scrollViewMain: UIScrollView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var txtName: MDCOutlinedTextField!
    @IBOutlet weak var txtEmail: MDCOutlinedTextField!
    @IBOutlet weak var txtPassword: MDCOutlinedTextField!
    @IBOutlet weak var btnUpdateWhole: UIControl!
    @IBOutlet weak var btnUpdateCheck: UIButton!
    @IBOutlet weak var lblUpdate: UILabel!
    @IBOutlet weak var btnSubmit: SMButton!
    @IBOutlet weak var lblAlreadyLogin: UILabel!
    @IBOutlet weak var btnAlreadyLogin: SMButton!
    @IBOutlet weak var progressBar: SMProgressBar!
    @IBOutlet weak var lblPasswordMessage: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    
    fileprivate var VMRegister = ViewModelRegister()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.appRemoveAllController(LoginVC.self)
        setupUI()
        updateEmailUI()
        //Update password progress and its view
        self.progressBar.isHidden = false
        VMRegister.passwordProgressChanged = { progress in
            let pwdCount = self.VMRegister.credentials.password.count
            self.lblPasswordMessage.isHidden = (pwdCount < 1)
//            self.progressBar.isHidden = (pwdCount < SMValidator.minPasswordLimit)
            self.progressBar.currentProgress = progress
        }
    }
    
    // MARK: - Action
    
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitClicked(_ sender: Any) {
        
        if VMRegister.validate() {
            
            if let nameError = VMRegister.nameError {
                txtName.leadingAssistiveLabel.text = nameError
            }
            
            if let emailError = VMRegister.emailError {
                txtEmail.leadingAssistiveLabel.text = emailError
            }
            
            if let passwordError = VMRegister.passwordError {
                txtPassword.leadingAssistiveLabel.text = passwordError
            }
            
        } else {
            SMHud.animate()
            self.VMRegister.registerUser { result, isSucess, message in
                SMHud.dimiss()
                if isSucess {
                    if let verification = AppStoryboard.main.viewController(EMailVerificationPage.self) {
                        verification.email = self.VMRegister.credentials.email
                        verification.password = self.VMRegister.credentials.password
                        verification.isFromRegister = true
                        self.navigationController?.pushViewController(verification, animated: true)
                    }
                } else if let err = message {
                    self.view.makeToast(err, style: APPGloble.toastStyleWhite)
                }
            }
        }
        
    }
    
    @IBAction func updateClicked(_ sender: Any) {
        VMRegister.setUpdateStatus(!VMRegister.credentials.isUpdate)
        updateEmailUI()
    }
    
    @IBAction func gotoLoginClicked(_ sender: Any) {
        if let login = AppStoryboard.main.viewController(LoginVC.self) {
            self.navigationController?.pushViewController(login, animated: true)
        }
    }
    
    // MARK: - Helper
    func setupUI() {
        btnBack.setTitle("back-button".translated, for: .normal)
        lblTitle.text = "e-mail_registration_title".translated
        lblDescription.text = "e-mail_registration_subtitle".translated
        lblUpdate.text = "e-mail_registration_opti-in".translated
        lblAlreadyLogin.text = "e-mail_registration_bottom-text".translated
        btnSubmit.setTitle("next-button".translated, for: .normal)
        btnAlreadyLogin.setTitle("e-mail_registration_bottom-login-button".translated, for: .normal)
        lblPasswordMessage.text = "e-mail_registration_prerequisites".translated
        
        //Configure textfields
        txtName.label.text = "e-mail_registration_name-field".translated
        txtEmail.label.text = "e-mail-field".translated
        txtPassword.label.text = "password-field".translated
        //Set White bordered theme
        txtName.themeWhiteBordered()
        txtEmail.themeWhiteBordered()
        txtPassword.themeWhiteBordered()
        //Set Identifiers
        txtName.accessibilityIdentifier = TextFieldIdetifier.name.rawValue
        txtEmail.accessibilityIdentifier = TextFieldIdetifier.email.rawValue
        txtPassword.accessibilityIdentifier = TextFieldIdetifier.password.rawValue
        //Add Observers
        txtName.addTextChanges(VMRegister, action: #selector(VMRegister.textFieldTextChanged(_:)))
        txtEmail.addTextChanges(VMRegister, action: #selector(VMRegister.textFieldTextChanged(_:)))
        txtPassword.addTextChanges(VMRegister, action: #selector(VMRegister.textFieldTextChanged(_:)))
        
        txtPassword.enablePasswordToggle()
    }
    
    func updateEmailUI() {
        btnUpdateCheck.isSelected = VMRegister.credentials.isUpdate
//        btnUpdateCheck.tintColor = VMRegister.credentials.isUpdate ? UIColor.appSkyBlue:UIColor.clear
//        btnUpdateCheck.borderColor = VMRegister.credentials.isUpdate ? UIColor.appSkyBlue:UIColor.appBorder
//        btnUpdateCheck.borderWidth = 1
//        btnUpdateCheck.clipsToBounds = true
//        btnUpdateCheck.cornerRadius = btnUpdateCheck.bounds.height / 2
    }
}
