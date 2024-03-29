//
//  InfoPopupVC.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 13/03/24.
//

import UIKit



class InfoPopupVC: UIViewController {
    
    struct SMInfoConfigurations {
        ///Title you want to show
        var title:String?
        ///Button 2 configuration. Set nill if you want to hide this button
        var items:[String]
        /// Submit  configuration. Defualt would be appSkyBlue background with white text
        var buttonConfig:SMButtonConfigurations = SMButtonConfigurations(idetifier: "submit", title: "Okay", background: UIColor.appSkyBlue, borderColors: nil, textColor: UIColor.appWhite)
        ///Pass true if you want to manually close screen otherwise it will be dismiss screen on button action . Defualt value is false
        var isDisableDismissScreen:Bool = false
        /// Show or hide close button according this values
        var isShowCloseButton = false
    }
    
    @IBOutlet weak var baseViewPopup: UIView!
    @IBOutlet var baseStakViewPopup: UIStackView!
    @IBOutlet weak var viewTitle: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var stackViewItems: UIStackView!
    @IBOutlet weak var btnSubmit: SMButton!
    @IBOutlet weak var btnClose: SMButton!
    
    var configuration:SMInfoConfigurations!
    var popupCloseWithHandler:((String) -> ())? = nil
    
    // MARK: - Lifecycle
    /// Helps to create instance of SMPopupVC with configuration
    static func load(withConfiguration config:SMInfoConfigurations) -> InfoPopupVC {
        let popup = InfoPopupVC(nibName: "InfoPopupVC", bundle: nil)
        popup.configuration = config
        return popup
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.showAnimation()
    }
    
    // MARK: - Actions
    @IBAction func submitClicked(_ sender: SMButton) {
        if configuration.isDisableDismissScreen {
            self.popupCloseWithHandler?(sender.buttonID)
        } else {
            self.hideAnimation(completions: {
                self.dismiss(animated: false) {
                    self.popupCloseWithHandler?(sender.buttonID)
                }
            }, view: baseViewPopup)
        }
    }
    
    @IBAction func closeClicked(_ sender: SMButton) {
        submitClicked(sender)
    }
    
    // MARK: - Helpers
    private func setupUI() {
        baseViewPopup.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        btnClose.setTitle( " " + "routes_page_info-close-button".translated, for: .normal)
        btnClose.isHidden = !configuration.isShowCloseButton
        btnClose.buttonID = "close"
        
        //Configure title
        lblTitle.text = configuration.title?.translated
        viewTitle.isHidden = SMValidator.isEmptyString(configuration.title)
        
        //Configuare buttons
        let btn1Config = configuration.buttonConfig
        btnSubmit.buttonID = btn1Config.idetifier
        btnSubmit.setTitle(btn1Config.title?.translated, for: .normal)
        btnSubmit.setTitleColor(btn1Config.textColor, for: .normal)
        btnSubmit.backgroundColor = btn1Config.background
        btnSubmit.borderColor = btn1Config.borderColors
        btnSubmit.borderWidth = btn1Config.borderColors == nil ? 0:1
        btnSubmit.isHidden = false
        
        //Configuare Items
        stackViewItems.subviews.forEach { subView in
            subView.removeFromSuperview()
        }
        for strItem in configuration.items {
            stackViewItems.addArrangedSubview(createLabel(strItem))
        }
        
    }
    /// Create label using given string with defualt configuration
    /// - Parameters:
    ///     - item:  it should be String which you want to show
    private func createLabel(_ item:String) -> UILabel {
        let lbl = UILabel()
        lbl.text = item
        lbl.font = AppFont.medium(size: 15)
        lbl.textColor = UIColor.appDarkBlue
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }
    
    ///Show popup animation
    private func showAnimation() {
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.7),
                       initialSpringVelocity: CGFloat(0.1),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
            self.baseViewPopup.transform = .identity
            self.view.backgroundColor = UIColor.appDarkBlue.withAlphaComponent(0.8)
        }) { finish in
            
        }
    }
    ///Hide popup animation
    private func hideAnimation(completions: @escaping (() -> ()),view:UIView) {
        UIView.animate(withDuration: 0.2) {
            view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.view.backgroundColor = .clear
        } completion: { finish in
            completions()
        }
    }
}
