//
//  ResetPasswordVC.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 16/02/24.
//

import UIKit
import DPOTPView
import MaterialComponents

class ResetPasswordVC: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var txtPassword: MDCOutlinedTextField!
    @IBOutlet weak var otpView: DPOTPView!
    @IBOutlet weak var btnSubmit: SMButton!
    @IBOutlet weak var lblPaswordPlaceholder: UILabel!
    @IBOutlet weak var lblPaswordValidation: UILabel!
    @IBOutlet weak var progressBar: SMProgressBar!
    @IBOutlet weak var btnBack: UIButton!
   
    fileprivate var VMResetPassword = ViewModeResetPassword()
    var email:String = ""
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        VMResetPassword.email = email
        self.progressBar.isHidden = false
        VMResetPassword.passwordProgressChanged = { progress in
            //Update UI
            let pwdCount = self.VMResetPassword.strPassword?.count ?? 0
            self.lblPaswordValidation.isHidden = (pwdCount < 1)
//            self.progressBar.isHidden = (pwdCount < SMValidator.minPasswordLimit)
            self.progressBar.currentProgress = progress
        }
    }
    

    // MARK: - Actions
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func submitClicked(_ sender: Any) -> Void {
        VMResetPassword.strCode = otpView.text
        if VMResetPassword.validate() {
            //Show errors
            if let error = self.VMResetPassword.passwordError {
                self.txtPassword.leadingAssistiveLabel.text = error
//                self.txtPassword.showError(message: error)
            }
            self.updateCodeError()
        } else {
            
            VMResetPassword.confirmNewPasword { result, isSucess, message in
                if isSucess {
                    self.view.makeToast(result?.message ?? "success".translated, duration: 1, style: APPGloble.toastStyleWhite,completion: { didTap in
                        //Redirect to login page
                        self.navigationController?.appRemoveAllController(SendCodeVC.self)
                        self.navigationController?.popViewController(animated: true)
                    })
                } else {
                    if !SMValidator.isEmptyString(result?.message) {
                        UIApplication.shared.firstKeyWindow?.makeToast(result!.message!.translated, style: APPGloble.toastStyleWhite)
                    }
                }
            }
           
        }
    }
    
    // MARK: - Helper
    func setupUI() {
        btnBack.setTitle("back-button".translated, for: .normal)
        lblTitle.text = "reset_password_title".translated
        lblDescription.text = "e-mail_confirmation_code_subtitle".translated
        lblPaswordPlaceholder.text = "reset_password_new_password-subtitle".translated
        btnSubmit.setTitle("reset_password_new_password-button".translated, for: .normal)
        lblPaswordValidation.text = "e-mail_registration_prerequisites".translated
        otpView.fontTextField = AppFont.medium(size: 15.0)
        otpView.dpOTPViewDelegate = self
        txtPassword.label.text = "reset_password_new_password-field".translated
        txtPassword.accessibilityIdentifier = TextFieldIdetifier.password.rawValue
        txtPassword.themeWhiteBordered()
        txtPassword.enablePasswordToggle()
        txtPassword.addTextChanges(VMResetPassword, action: #selector(VMResetPassword.textFieldTextChanged(_:)))
        
    }
    
    func updateCodeError() {
        if let error = VMResetPassword.codeError {
            lblPaswordPlaceholder.text = error.translated
            lblPaswordPlaceholder.textColor = UIColor.appRed
        } else {
            lblPaswordPlaceholder.text = "reset_password_new_password-subtitle".translated
            lblPaswordPlaceholder.textColor = UIColor.appWhite
        }
    }

}

extension ResetPasswordVC: DPOTPViewDelegate {
    func dpOTPViewAddText(_ text: String, at position: Int) {
        VMResetPassword.codeError = nil
        updateCodeError()
    }
    
    func dpOTPViewRemoveText(_ text: String, at position: Int) {
        VMResetPassword.codeError = nil
        updateCodeError()
    }
    
    func dpOTPViewChangePositionAt(_ position: Int) {
    }
    
    func dpOTPViewBecomeFirstResponder() {
       
    }
    
    func dpOTPViewResignFirstResponder() {
    }
    
    
}
