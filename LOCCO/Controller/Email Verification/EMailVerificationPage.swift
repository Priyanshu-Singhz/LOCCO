//
//  EMailVerificationPage.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 14/02/24.
//

import UIKit
import DPOTPView

class EMailVerificationPage:UIViewController {
    //MARK: - Variable's
    @IBOutlet weak var contentBGView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subTitleLbl: UILabel!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var otpErrorLbl: UILabel!
    @IBOutlet weak var otpView: DPOTPView!
    @IBOutlet weak var notReciveOtpLbl: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    ///This field must be require to verify or resend  otp
    var email:String = ""
    ///this field require after registration. To login user directly
    var password:String = ""
    
    var isFromRegister:Bool = false
    var sessionInfo:SessionInfo? = nil
    
    private var resendCodeTimer:Timer? = nil
    private var resendTime:Int = 30
    
    
    //MARK: - View Life Cycle's
    override func viewDidLoad() {
        super.viewDidLoad()
        otpView.dpOTPViewDelegate = self
        setAttributeOtpText()
        setupUI()
        startTimer()
    }
    //MARK: - Helper
    func setupUI() {
        btnBack.setTitle("reminder_page_new_reminder-cancel".translated, for: .normal)
        // Round contentBGView corners
        contentBGView.roundCorners(corners: [.topLeft, .topRight], radius: 32)
        // Set up OTP view
        otpView.fontTextField = AppFont.medium(size: 15)
        otpView.textColorTextField = .appSkyBlue
        // Set up title label
        if isFromRegister {
            titleLbl.text = "e-mail_confirmation_code_title".translated
        } else {
            titleLbl.text = "e-mail_confirmation_not_verified-title".translated
        }
        // Set up subtitle label
        subTitleLbl.text = "e-mail_confirmation_code_subtitle".translated
        // Set up Start LOCCO button
        btnStart.setTitle("e-mail_confirmation_code_button".translated, for: .normal)
    }
    
    func startTimer() {
        stopTimer()
        self.resendCodeTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerChange), userInfo: nil, repeats: true)
    }
    
    func stopTimer()  {
        self.resendCodeTimer?.invalidate()
        self.resendCodeTimer = nil
    }
    
    @objc func timerChange() {
        resendTime -= 1
        if resendTime <= 0 {
            resendTime = 0
            self.stopTimer()
        }
        self.setAttributeOtpText()
    }
    // Attributed Otp Not Received Label
    func setAttributeOtpText(){
        let resultText = textForResend()
        // Set up attributed string with different attributes
        let attributedString = NSMutableAttributedString(string: resultText.full)
        // Apply blue color to "Send again" part
        let sendAgainRange = (resultText.full as NSString).range(of: resultText.resendText)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.appSkyBlue, range: sendAgainRange)
        // Apply line spacing
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        //(attributedString.string as! NSString).range(of: "Send again.")
        // Apply the attributed string to the label
        notReciveOtpLbl.attributedText = attributedString
        // Set font
        notReciveOtpLbl.font = AppFont.medium(size: 15)
        // Enable user interaction on the label
        notReciveOtpLbl.isUserInteractionEnabled = true
        // Add tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        notReciveOtpLbl.addGestureRecognizer(tapGesture)
        
    }
    
    func textForResend() -> (full:String, resendText:String) {
        var stringToSet = "e-mail_confirmation_code_bottom-text".translated
        var resendText:String = " " + "e-mail_confirmation_code_bottom-link".translated
        if resendTime > 0 {
            resendText = " " + "e-mail_confirmation_code_resend".translated + "(\(resendTime))"
        }
        stringToSet += resendText
        return(stringToSet, resendText)
    }
    //MARK: - Action's
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // tap Event of Send Again Text
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        // Get the location of the tap in the label
        let tapLocation = gesture.location(in: notReciveOtpLbl)
        // Determine the tapped character index
        let characterIndex = notReciveOtpLbl.characterIndex(at: tapLocation)
        // Check if the tapped character is within the "Send again" range
        let resultText = textForResend()
        let sendAgainRange = (resultText.full as NSString).range(of: resultText.resendText)
        if NSLocationInRange(characterIndex, sendAgainRange) {
            print("Send again tapped!")
            if resendTime <= 0 {
                //resend code
                self.resendCode()
            }
        }
    }
    
    @IBAction func btnStartClicked(_ sender: UIButton) {
        otpView.endEditing(true)
        self.otpErrorLbl.isHidden = true
        self.verifyCode()
    }
    
    //MARK: - API
    
    func verifyCode() {
        SMHud.animate()
        ViewModelRegister.confirmCode(email: email, code: otpView.text!, completion: { result,isSucess,message in
            
            if isSucess {
                if self.isFromRegister {
                    // Login api call and move to dashboard
                    self.loginUser()
                } else {
                    SMHud.dimiss()
                    UIApplication.shared.firstKeyWindow?.makeToast(message ?? "sucess", style: APPGloble.toastStyleWhite, completion: { didTap in
                        //Load dashboard
                        UserSession.shared.saveSession(session: self.sessionInfo)
                        UIApplication.appDelegate?.switchToHome()
                    })
                }
                
            } else if let err = message {
                SMHud.dimiss()
                self.otpErrorLbl.text  = err
                self.otpErrorLbl.isHidden = false
            }
        })
    }
    
    func resendCode() {
        SMHud.animate()
        ViewModelRegister.resendCode(email: email) { result, isSucess, message in
            SMHud.dimiss()
           
            if isSucess {
                UIApplication.shared.firstKeyWindow?.makeToast((message ?? "success").translated, style: APPGloble.toastStyleWhite)
                self.resendTime = 30
                self.startTimer()
            } else {
                if !SMValidator.isEmptyString(message) {
                    UIApplication.shared.firstKeyWindow?.makeToast(message!.translated, style: APPGloble.toastStyleWhite)
                }
            }
        }
    }
    
    func loginUser() {
        let creds = ModelLogin(email: email, password: password)
        ViewModelLogin.loginUser(credentials: creds) { result, isSucess, message in
            SMHud.dimiss()
            if isSucess {
                //Save details locallly
                UserSession.shared.saveSession(session:  result?.data)
                //Redirect to dashboard
                UIApplication.appDelegate?.switchToHome()
            } else {
                // go to Login page
                if let login = AppStoryboard.main.viewController(LoginVC.self) {
                    self.navigationController?.pushViewController(login, animated: true)
                }
            }
        }
    }
    
}
//MARK: - DPOTPViewDelegate
extension EMailVerificationPage : DPOTPViewDelegate {
    //Add text into Otp Text Field
    func dpOTPViewAddText(_ text: String, at position: Int) {
        // Enable and disable the Start Locco Button
        btnStart.isEnabled = text.count == 6 ? true : false
        // Adjust the Start Locco Button Color Opacity
        btnStart.alpha = text.count == 6 ? 1 : 0.30
    }
    //Remove text into Otp Text Field
    func dpOTPViewRemoveText(_ text: String, at position: Int) {
        print("removeText:- " + text + " at:- \(position)" )
    }
    //Change the text Particular Position On Otp Text Field
    func dpOTPViewChangePositionAt(_ position: Int) {
        print("at:-\(position)")
    }
    //OTPViewBecomeFirstResponder
    func dpOTPViewBecomeFirstResponder() {}
    //OTPViewResignFirstResponder
    func dpOTPViewResignFirstResponder() {}
}

// Extension to find character index at a given point in a label
extension UILabel {
    func characterIndex(at point: CGPoint) -> Int {
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: attributedText ?? NSAttributedString())
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = lineBreakMode
        textContainer.maximumNumberOfLines = numberOfLines
        textContainer.size = bounds.size
        
        let glyphIndex = layoutManager.glyphIndex(for: point, in: textContainer)
        let characterIndex = layoutManager.characterIndexForGlyph(at: glyphIndex)
        
        return characterIndex
    }
}
