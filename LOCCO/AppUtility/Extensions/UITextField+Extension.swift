//
//  UITextField+Extension.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 16/02/24.
//

import UIKit
import MaterialComponents

extension MDCOutlinedTextField {
    ///Set the white bordered textfield.
    func themeWhiteBordered() {
        self.placeholder = nil
        self.containerRadius = 16
        self.leadingEdgePaddingOverride = 20
        self.leadingViewMode = .always
        self.label.font =  self.font
        
        self.setLeadingAssistiveLabelColor(UIColor.appRed, for: .normal)
        self.setLeadingAssistiveLabelColor(UIColor.appRed, for: .editing)
        self.setLeadingAssistiveLabelColor(UIColor.appRed, for: .disabled)
        
        self.setFloatingLabelColor(.appWhite.withAlphaComponent(0.6), for: .editing)
        self.setFloatingLabelColor(.appWhite.withAlphaComponent(0.6), for: .normal)
        self.setFloatingLabelColor(.appWhite.withAlphaComponent(0.6), for: .disabled)
        
        self.setOutlineColor(.appBorder, for: .editing)
        self.setOutlineColor(.appBorder, for: .normal)
        self.setOutlineColor(.appBorder, for: .disabled)
        
        self.setNormalLabelColor(.appWhite.withAlphaComponent(0.3), for: .editing)
        self.setNormalLabelColor(.appWhite.withAlphaComponent(0.3), for: .normal)
        self.setNormalLabelColor(.appWhite.withAlphaComponent(0.3), for: .disabled)
        
        self.setTextColor(.appBorder, for: .editing)
        self.setTextColor(.appBorder, for: .normal)
        self.setTextColor(.appBorder, for: .disabled)
    }
    
    ///Set the white bordered textfield.
    func themeWhiteFill(isCustomColor:UIColor = .appSkyBlue,isPasswordColor:Bool = false) {
        self.placeholder = nil
        self.containerRadius = 16
        self.leadingEdgePaddingOverride = 20
        self.leadingViewMode = .always
        self.label.font =  self.font
        
        self.setLeadingAssistiveLabelColor(UIColor.appRed, for: .normal)
        self.setLeadingAssistiveLabelColor(UIColor.appRed, for: .editing)
        self.setLeadingAssistiveLabelColor(UIColor.appRed, for: .disabled)
        
        self.setFloatingLabelColor(isPasswordColor ?.appDarkGrey : .appSkyBlue, for: .editing)
        self.setFloatingLabelColor(isPasswordColor ?.appDarkGrey :isCustomColor, for: .normal)
        self.setFloatingLabelColor(isCustomColor, for: .disabled)
        
        self.setOutlineColor(.appSkyBlue, for: .editing)
        self.setOutlineColor(isCustomColor, for: .normal)
        self.setOutlineColor(.appSkyBlue, for: .disabled)
        
        self.setNormalLabelColor(.appSkyBlue, for: .editing)
        self.setNormalLabelColor(isPasswordColor ? .appDarkGrey :isCustomColor, for: .normal)
        self.setNormalLabelColor(isCustomColor, for: .disabled)
        
        self.setTextColor(.appDarkBlue, for: .editing)
        self.setTextColor(isCustomColor, for: .normal)
        self.setTextColor(isCustomColor, for: .disabled)
    }
}
extension UITextField {
    
    
    func addTextChanges(_ targat: Any?, action: Selector) {
        addTarget(targat, action: action, for: .editingChanged)
    }
    
    // Mark Password
    func enablePasswordToggle(_ tint:UIColor = UIColor.appBorder) {
        
        var config = UIButton.Configuration.plain()
        
        let image2Set = self.isSecureTextEntry ?
        UIImage(systemName: "eye", withConfiguration: UIImage.SymbolConfiguration(scale: .small)) :
        UIImage(systemName: "eye.slash", withConfiguration: UIImage.SymbolConfiguration(scale: .small))
        config.image = image2Set
        config.baseBackgroundColor = .clear
        let btnEye = UIButton(configuration: config)
        btnEye.tintColor = tint
        btnEye.configurationUpdateHandler = { button in
            var config = button.configuration
            config?.image = self.isSecureTextEntry ?
            UIImage(systemName: "eye") :
            UIImage(systemName: "eye.slash")
            button.configuration = config
        }
        btnEye.addTarget(self, action: #selector(self.togglePasswordView(_:)), for: .touchUpInside)
        btnEye.sizeToFit()
        self.rightView = btnEye
        self.rightViewMode = .always
    }
    
    @IBAction func togglePasswordView(_ sender: UIButton) {
        self.isSecureTextEntry = !self.isSecureTextEntry
        sender.isSelected = self.isSecureTextEntry
    }
}
