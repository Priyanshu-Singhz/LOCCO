//
//  SMPopupVC.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 28/02/24.
//

import UIKit

struct SMPopupConfigurations {
    ///Title you want to show
    var title:String?
    ///Description you want to show.
    var description:String?
    ///Description you want to Attributed.
    var attributedDescription:NSAttributedString?
    /// get the navigation form which screen
    var isScreen:String?
    /// Button 1 configuration. Set nill if you want to hide this button
    var button1:SMButtonConfigurations?
    ///Button 2 configuration. Set nill if you want to hide this button
    var button2:SMButtonConfigurations?
}

struct SMButtonConfigurations {
    ///Identifier to detect buton
    var idetifier:String
    ///Tilte of button
    var title:String?
    ///The button background color.
    var background:UIColor?
    ///The color of the layer’s border. Animatable.
    var borderColors:UIColor?
    ///The button text color.
    var textColor:UIColor?
}

class SMPopupVC: UIViewController {
    @IBOutlet weak var baseViewPopup: UIView!
    @IBOutlet var baseStakViewPopup: UIStackView!
    @IBOutlet weak var viewTitle: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewDescription: UIView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var viewButtons: UIView!
    @IBOutlet weak var btn1: SMButton!
    @IBOutlet weak var btn2: SMButton!
    @IBOutlet var baseViewPopupHeight: NSLayoutConstraint!
    @IBOutlet var stackViewBottomConstant: NSLayoutConstraint!
    var configuration:SMPopupConfigurations!
    var popupCloseWithHandler:((String) -> ())? = nil
    var backgroundOverlay: UIView?
    // MARK: - Lifecycle
    /// Helps to create instance of SMPopupVC with configuration
    static func load(withConfiguration config:SMPopupConfigurations) -> SMPopupVC {
        let popup = SMPopupVC(nibName: "SMPopupVC", bundle: nil)
        popup.configuration = config
        return popup
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Add a tap gesture recognizer's
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.view.addGestureRecognizer(tapGesture)
        backgroundOverlay?.addGestureRecognizer(tapGesture)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addBackgroundOverlay()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeBackgroundOverlay()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.showAnimation()
    }
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: self.view)
        // Check if the tap is outside the baseViewPopup
        if !baseViewPopup.frame.contains(point) {
            self.hideAnimation(completions: {
                self.dismiss(animated: false) {}
            },view: baseViewPopup)
        }
    }
    // MARK: - Actions
    @IBAction func buttonClicked(_ sender: SMButton) {
        self.hideAnimation(completions: {
            self.dismiss(animated: false) {
                self.popupCloseWithHandler?(sender.buttonID)
            }
        }, view: baseViewPopup)
    }
    //Add Background Overlay
    func addBackgroundOverlay() {
        let overlay = UIView(frame: UIScreen.main.bounds)
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlay.alpha = 0
        self.view.insertSubview(overlay, belowSubview: baseViewPopup)
        backgroundOverlay = overlay
        UIView.animate(withDuration: 0.3) {
            overlay.alpha = 1.0
        }
    }
    //Remove Background Overlay
    func removeBackgroundOverlay() {
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundOverlay?.alpha = 0
        }) { _ in
            self.backgroundOverlay?.removeFromSuperview()
            self.backgroundOverlay = nil
        }
    }
    // MARK: - Helpers
    private func setupUI() {
        baseViewPopup.transform = CGAffineTransform(scaleX: 0, y: 0)
        //Configure title
        lblTitle.text = configuration.title?.translated
        viewDescription.isHidden = SMValidator.isEmptyString(configuration.title)
        
        //Configure Description
        viewDescription.isHidden = true
        if let desc = configuration.description?.translated {
            lblDescription.text = desc
            viewDescription.isHidden = false
        } else if let desc = configuration.attributedDescription {
            let attributedDesc = NSAttributedString(string: desc.string.translated)
            lblDescription.attributedText = attributedDesc
            viewDescription.isHidden = false
        }
        
        //Configuare buttons
        if let btn1Config = configuration.button1 {
            btn1.buttonID = btn1Config.idetifier
            btn1.setTitle(btn1Config.title?.translated, for: .normal)
            btn1.setTitleColor(btn1Config.textColor, for: .normal)
            btn1.backgroundColor = btn1Config.background
            btn1.borderColor = btn1Config.borderColors
            btn1.borderWidth = btn1Config.borderColors == nil ? 0:1
            btn1.isHidden = false
        } else {
            btn1.isHidden = true
        }
        
        if let btn2Config = configuration.button2 {
            btn2.buttonID = btn2Config.idetifier
            btn2.setTitle(btn2Config.title?.translated, for: .normal)
            btn2.setTitleColor(btn2Config.textColor, for: .normal)
            btn2.backgroundColor = btn2Config.background
            btn2.borderColor = btn2Config.borderColors
            btn2.borderWidth = btn2Config.borderColors == nil ? 0:1
            btn2.isHidden = false
        } else {
            btn2.isHidden = true
        }
//        // For Driving Mode VC
//        if let config = configuration.isScreen{
//            if config == "DrivingModeVC" {
//                baseViewPopupHeight.constant = 284
//                baseStakViewPopup.spacing = 24
//                stackViewBottomConstant.constant = 24
//            }
//        }
    }
    
    private func showAnimation() {
        
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.7),
                       initialSpringVelocity: CGFloat(0.1),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
            self.baseViewPopup.transform = .identity
        }) { finish in
            
        }
    }
    // Hide Animation
    private func hideAnimation(completions: @escaping (() -> ()),view:UIView) {
        UIView.animate(withDuration: 0.2) {
            view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        } completion: { finish in
            completions()
        }
    }
//    private func hideAnimation(completions: @escaping (() -> ())) {
//        UIView.animate(withDuration: 0.2) {
//            self.baseViewPopup.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
//        } completion: { finish in
//            completions()
//        }
//    }

}
