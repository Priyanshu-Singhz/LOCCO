//
//  SMNavigationBar.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 21/02/24.
//

import UIKit

class SMNavigationBar: UIView {
    let kCONTENT_XIB_NAME = "SMNavigationBar"
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    
    ///title of navigation bar
    @IBInspectable var navigationTitle:String? {
        get { return lblTitle.text }
        set { lblTitle.text = newValue}
    }
    /// Back button textColor and tintColor
    @IBInspectable var backButtonColor:UIColor {
        get { return btnBack.tintColor }
        set {
            btnBack.tintColor = newValue
            btnBack.setTitleColor(newValue, for: .normal)
        }
    }
    /// Title textColor
    @IBInspectable var titleColor:UIColor {
        get { return lblTitle.textColor }
        set {lblTitle.textColor = newValue }
    }
    
  
    var backButtonClicked:((SMButton) -> ())? = nil
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
        btnBack.addTarget(self, action: #selector(self.backClicked(_:)), for: .touchUpInside)
        btnBack.setTitle("back-button".translated, for: .normal)
    }
    
    //MARK: - Helper
 
    @objc func backClicked(_ sender:SMButton) {
        backButtonClicked?(sender)
    }
}
