//
//  SMProgressBar.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 15/02/24.
//

import UIKit

class SMProgressBar: UIView {
    let kCONTENT_XIB_NAME = "SMProgressBar"
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var lblStatus: UILabel!
    
    
    ///Adjusts the current progress of the progress view, optionally animating the change.
    var currentProgress:Float {
        get { return progressBar.progress }
        set {
            progressBar.setProgress(newValue, animated: true)
            updateProgressUI(newValue)
        }
    }
    
    /// The color shown for the portion of the progress bar that’s filled.
    var progressTintColor:UIColor = UIColor.appSkyBlue {
        didSet { progressBar.progressTintColor = progressTintColor }
    }
    
    ///The color shown for the portion of the progress bar that isn’t filled.
    ///
    ///If you set trackTintColor to nil, the track uses the tint of its parent.
    var trackTintColor:UIColor? = nil {
        didSet {
            progressBar.trackTintColor = trackTintColor
        }
    }
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
        contentView.fixInView(self)
        
        let radius = progressBar.frame.height/2
        progressBar.layer.cornerRadius = radius
        progressBar.clipsToBounds = true
        progressBar.layer.sublayers![1].cornerRadius = radius
        progressBar.subviews[1].clipsToBounds = true
        updateProgressUI()
    }
    
    //MARK: - Private methods
    
    func updateProgressUI(_ strength:Float = -1.0) {
        let currentStrength = strength > 0.0 ? strength:currentProgress
        let resultInfo = colorForStrength(currentStrength)
        progressTintColor = resultInfo.color
        lblStatus.text = resultInfo.text.translated
        lblStatus.textColor = resultInfo.color
    }
    
    /// Helps to find related color according strength of pasword
    /// - Parameters:
    ///     - strength:  Strength of passwod. should be between 0 to 1.
    private func colorForStrength(_ strength:Float) -> (color:UIColor, text:String) {
        if strength <= 0.25 {
            return (UIColor.appRed, "e-mail_registration_password-strength-weak")
        } else if strength <= 0.50 {
            return (UIColor.appOrange, "e-mail_registration_password-strength-ok")
        } else if strength <= 0.75 {
            return (UIColor.appOrange, "e-mail_registration_password-strength-good")
        }
        return (UIColor.appSkyBlue, "e-mail_registration_password-strength-strong")
    }
}

extension UIView{
    /// Help to fix given view in current view
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
