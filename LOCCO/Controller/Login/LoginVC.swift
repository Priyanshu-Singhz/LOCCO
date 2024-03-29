//
//  LoginVC.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 13/02/24.
//

import UIKit
import MaterialComponents
import GoogleSignIn


class LoginVC: UIViewController {
    
    @IBOutlet weak var scrollviewMain: UIScrollView!
    @IBOutlet weak var stackViewMain: UIStackView!
    @IBOutlet weak var popupBlue: UIView!
    @IBOutlet weak var lblLoginPlaceholder: UILabel!
    @IBOutlet weak var txtEmail: MDCOutlinedTextField!
    @IBOutlet weak var txtPassword: MDCOutlinedTextField!
    @IBOutlet weak var btnForgotPassword: SMButton!
    @IBOutlet weak var btnLogin: SMButton!
    @IBOutlet weak var lblContinueWith: UILabel!
    @IBOutlet weak var lblNoAccount: UILabel!
    @IBOutlet weak var btnRegisternow: SMButton!
    @IBOutlet weak var btnBack: UIButton!
    
    fileprivate var VMLogin = ViewModelLogin()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.appRemoveAllController([RegisterVC.self, EMailVerificationPage.self])
        setupUI()
    }
    
    // MARK: - Helper
    func setupUI() {
        btnBack.setTitle("back-button".translated, for: .normal)
        popupBlue.roundCorners(corners: [.topLeft, .topRight], radius: 16)
        lblLoginPlaceholder.text = "e-mail_login_title".translated
        txtEmail.label.text = "e-mail-field".translated
        txtPassword.label.text = "password-field".translated
        btnForgotPassword.setTitle("e-mail_login_forgot-password".translated, for: .normal)
        btnLogin.setTitle("welcome_page_login-button".translated, for: .normal)
        lblNoAccount.text = "e-mail_login_bottom-text".translated
        lblContinueWith.text = "welcome_page_divider".translated
        btnRegisternow.setTitle("e-mail_login_bottom-link".translated, for: .normal)
        txtEmail.themeWhiteBordered()
        txtPassword.themeWhiteBordered()
        //Add observer for text changes
        txtEmail.accessibilityIdentifier = TextFieldIdetifier.email.rawValue
        txtPassword.accessibilityIdentifier = TextFieldIdetifier.password.rawValue
        txtEmail.addTextChanges(VMLogin, action: #selector(VMLogin.textFieldTextChanged(_:)))
        txtPassword.addTextChanges(VMLogin, action: #selector(VMLogin.textFieldTextChanged(_:)))
        txtPassword.enablePasswordToggle()
        
#if targetEnvironment(simulator)
        txtEmail.text = "sudhird@zignuts.com"
        txtPassword.text = "Sudhir@1234"
        VMLogin.credentials.email = "sudhird@zignuts.com"
        VMLogin.credentials.password = "Sudhir@1234"
#endif
    }
    
    
    
    // MARK: - Actions
    
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func forgotPasswordClicked(_ sender: Any) {
        if let sendCode = AppStoryboard.main.viewController(SendCodeVC.self) {
            self.navigationController?.pushViewController(sendCode, animated: true)
        }
        
    }
    
    @IBAction func submitClicked(_ sender: Any) {
        
        if VMLogin.validate() {
            
            if let emailError = VMLogin.emailError {
                txtEmail.leadingAssistiveLabel.text = emailError
            }
            
            if let passwordError = VMLogin.passwordError {
                txtPassword.leadingAssistiveLabel.text = passwordError
            }
            
        } else {
            SMHud.animate()
            ViewModelLogin.loginUser(credentials: VMLogin.credentials) { result, isSucess, message in
                SMHud.dimiss()
                let statusCode = result?.statusCode ?? 0
                if isSucess {
                    //Save details locallly
                    UserSession.shared.saveSession(session:  result?.data)
                    //Redirect to dashboard
                    UIApplication.appDelegate?.switchToHome()
                } else if statusCode == SMStatusCode.UserNotConfirmedException.rawValue {
                    self.navigateToVerifyOTP(result?.data)
                }else if let err = message {
                    self.view.makeToast(err, style: APPGloble.toastStyleWhite)
                }
            }
        }
    }
    
    @IBAction func appleClicked(_ sender: Any) {
        /*AppleAuth.shared.signInWithApple { response, message in
            if let credentials = response {
                SMHud.animate()
                ViewModelLogin.appleAuth(credentials: credentials) { result, isSucess, message in
                    SMHud.dimiss()
                    if isSucess {
                        //Save details locallly
                        UserSession.shared.saveSession(session:  result?.data)
                        //Redirect to dashboard
                        UIApplication.appDelegate?.switchToHome()
                    } else if let err = message {
                        self.view.makeToast(err, style: APPGloble.toastStyleWhite)
                    }
                }
            } else {
                self.view.makeToast(message, style: APPGloble.toastStyleWhite)
            }
        }*/
    }
    
    @IBAction func googleClicked(_ sender: Any) -> Void {
       /* GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in
            guard error == nil else {
                appPrint("Error",error as Any)
                return
            }
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                appPrint("Invalid user")
                return
            }
            var credential = ModelLogin()
            credential.socialID = idToken
            credential.givenName = user.profile?.givenName ?? ""
            credential.familyName = user.profile?.familyName ?? ""
            SMHud.animate()
            ViewModelLogin.googleAuth(credentials: credential) { result, isSucess, message in
                SMHud.dimiss()
                let statusCode = result?.statusCode ?? 0
                if isSucess {
                    //Save details locallly
                    UserSession.shared.saveSession(session:  result?.data)
                    //Redirect to dashboard
                    UIApplication.appDelegate?.switchToHome()
                } else if let err = message {
                    self.view.makeToast(err, style: APPGloble.toastStyleWhite)
                }
            }
            
        }*/
    }
    
    @IBAction func registerNowClicked(_ sender: Any) {
        if let register = AppStoryboard.main.viewController(RegisterVC.self) {
            self.navigationController?.pushViewController(register, animated: true)
        }
    }
    
    // MARK: - Helper
    
    func navigateToVerifyOTP(_ session:SessionInfo?) {
        if let verification = AppStoryboard.main.viewController(EMailVerificationPage.self) {
            verification.email = self.VMLogin.credentials.email
            verification.sessionInfo = session
            self.navigationController?.pushViewController(verification, animated: true)
        }
    }
}
