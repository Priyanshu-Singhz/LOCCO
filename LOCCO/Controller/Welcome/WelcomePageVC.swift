//
//  WelcomPage.swift
//  Locco-OnBoarding-Screen
//
//  Created by Zignuts Technolab on 13/02/24.
//

import UIKit
import GoogleSignIn
import AuthenticationServices

class WelcomePageVC:UIViewController {
    //MARK: - Variable's
    @IBOutlet weak var welcomeLbl: UILabel!
    @IBOutlet weak var btnCreateAccount: UIButton!
    @IBOutlet weak var contentBgView: UIView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnAppleLogin: UIButton!
    @IBOutlet weak var btnGoogleLogin: UIButton!
    @IBOutlet weak var lblContinue: UILabel!
    @IBOutlet weak var lblTerms: UILabel!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    //MARK: - Helper
    func updateUI(){
        contentBgView.roundCorners(corners: [.topLeft, .topRight], radius: 16)
        welcomeLbl.text = "welcome_page_title".translated
        lblContinue.text = "welcome_page_divider".translated
        btnCreateAccount.setTitle("welcome_page_register-button".translated, for: .normal)
        btnLogin.setTitle("welcome_page_login-button".translated, for: .normal)
        lblTerms.isUserInteractionEnabled = true
        lblTerms.attributedText = attributedTermsPrivacy()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(termsTap(_:)))
        lblTerms.addGestureRecognizer(tapGesture)
    }
    
    @objc func termsTap(_ gesture: UITapGestureRecognizer) {
        
        let result = getTermsPrivacyInfo()
        let termRange = (result.full as NSString).range(of: result.terms)
        if gesture.didTapAttributedTextInLabel(label: lblTerms, inRange: termRange) {
            print("terms of use clicked")
        }
        
        let privacyRange = (result.full as NSString).range(of: result.privacy)
        if gesture.didTapAttributedTextInLabel(label: lblTerms, inRange: privacyRange) {
            print("privacy policy clicked")
        }
    }
    
    func getTermsPrivacyInfo() -> (full:String, terms:String, privacy:String) {
        let textTerms = "welcome_page_legal-terms-hyperlink-terms-of-use".translated
        let textPrivacy = "welcome_page_legal-terms-hyperlink-privacy-policy".translated
        let fullText = "welcome_page_legal-terms".translated
        return (fullText, textTerms, textPrivacy)
    }
    /// returns attributed terms and provacy text
    func attributedTermsPrivacy() -> NSAttributedString {
        let result = getTermsPrivacyInfo()
        //Default cnfigurations
        let attributeTerms = NSMutableAttributedString(string: result.full,
                                                       attributes: [.foregroundColor: UIColor.appWhite,
                                                                    .font: AppFont.medium(size: 12)])
        //Create underline for terms of use
        let termRange = (result.full as NSString).range(of: result.terms)
        attributeTerms.addAttributes([.underlineStyle :  NSUnderlineStyle.thick.rawValue], range: termRange)
        //Create underline for privacy policy
        let privacyRange = (result.full as NSString).range(of: result.privacy)
        attributeTerms.addAttributes([.underlineStyle :  NSUnderlineStyle.thick.rawValue], range: privacyRange)
        
        return attributeTerms
    }
    
    //MARK: - Actions
    @IBAction func createAccountClicked(_ sender: Any) {
        if let register = AppStoryboard.main.viewController(RegisterVC.self) {
            self.navigationController?.pushViewController(register, animated: true)
        }
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        if let login = AppStoryboard.main.viewController(LoginVC.self) {
            self.navigationController?.pushViewController(login, animated: true)
        }
    }
    
    @IBAction func appleClicked(_ sender: Any) {
        AppleAuth.shared.signInWithApple { response, message in
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
        }
    }
    
    @IBAction func googleClicked(_ sender: Any) -> Void {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in
            guard error == nil else {
                appPrint("Error",error as Any)
                self.view.makeToast(error!.localizedDescription, style: APPGloble.toastStyleWhite)
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
                if isSucess {
                    //Save details locallly
                    UserSession.shared.saveSession(session:  result?.data)
                    //Redirect to dashboard
                    UIApplication.appDelegate?.switchToHome()
                } else if let err = message {
                    self.view.makeToast(err, style: APPGloble.toastStyleWhite)
                }
            }
            
        }
    }
}


extension UITapGestureRecognizer {

    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        //let textContainerOffset = CGPointMake((labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
        //(labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)

        //let locationOfTouchInTextContainer = CGPointMake(locationOfTouchInLabel.x - textContainerOffset.x,
        // locationOfTouchInLabel.y - textContainerOffset.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}
