//
//  SendCodeVC.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 16/02/24.
//

import UIKit
import MaterialComponents

class SendCodeVC: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var txtEmail: MDCOutlinedTextField!
    @IBOutlet weak var btnSubmit: SMButton!
    @IBOutlet weak var lblNoAccount: UILabel!
    @IBOutlet weak var btnNoAccount: SMButton!
    @IBOutlet weak var btnBack: UIButton!
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    

    // MARK: - Actions
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func registerClicked(_ sender: Any) {
        if let register = AppStoryboard.main.viewController(RegisterVC.self) {
            self.navigationController?.pushViewController(register, animated: true)
        }
    }
    
    @IBAction func submitClicked(_ sender: Any) {
        if let error = SMValidator.validate(email: txtEmail.text) {
            txtEmail.leadingAssistiveLabel.text = error
//            txtEmail.showError(message: error)
        } else {
            //Send code
            SMHud.animate()
            ViewModeResetPassword.forgotPassword(email: txtEmail.text!.trimed()) { result, isSucess, message in
                SMHud.dimiss()
               
                if isSucess {
                    self.view.makeToast(result?.message ?? "success".translated, duration: 1, style: APPGloble.toastStyleWhite,completion: { didTap in
                        if let resetPassword = AppStoryboard.main.viewController(ResetPasswordVC.self) {
                            resetPassword.email = self.txtEmail.text!
                            self.navigationController?.pushViewController(resetPassword, animated: true)
                        }
                    })
                   
                } else {
                    if !SMValidator.isEmptyString(result?.message) {
                        UIApplication.shared.firstKeyWindow?.makeToast(result!.message!, style: APPGloble.toastStyleWhite)
                    }
                }
            }
        }
    }
    
    // MARK: - Helper
    func setupUI() {
        btnBack.setTitle("back-button".translated, for: .normal)
        lblTitle.text = "reset_password_title".translated
        lblDescription.text = "reset_password_subtitle".translated
        lblNoAccount.text = "e-mail_login_bottom-text".translated
        btnSubmit.setTitle("reset_password_button".translated, for: .normal)
        btnNoAccount.setTitle("e-mail_login_bottom-link".translated, for: .normal)
        txtEmail.label.text = "e-mail-field".translated
        txtEmail.accessibilityIdentifier = TextFieldIdetifier.email.rawValue
        txtEmail.themeWhiteBordered()
        //txtEmail.themeWhiteBordered()
    }
}
