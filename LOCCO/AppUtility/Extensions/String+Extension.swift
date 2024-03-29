//
//  String+Extension.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 14/02/24.
//

import Foundation
import UIKit
extension String {
    func trimed() -> String{
        return  self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    
    func formatedSring(args:[CVarArg]) -> String {
        return String(format: self, arguments: args)
    }
    
    var isEmptyStr:Bool{
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces).isEmpty
    }
    var toDouble:Double? {
        return Double(self)
    }
    
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
    func attributedStringWithFont(for phraseToStyle: String, font: UIFont) -> NSAttributedString {
          // Create an attributed string from the original string
          let attributedString = NSMutableAttributedString(string: self)
          // Find the range of the specific phrase you want to style
        if let range = self.range(of: phraseToStyle) {
            let nsRange = NSRange(range, in: self)
            // Apply the font to the specific range
            attributedString.addAttribute(.font, value: font, range: nsRange)
        }
          return attributedString
      }
}

extension Date {
    func formatedWithtime() -> String {
        let formater = DateFormatter()
        formater.dateFormat = "dd.mm.yyyy HH:mm"
        return formater.string(from: self)
    }
}

class SMValidator {
    static let minPasswordLimit = 8
    static let maxPasswordLimit = 30
    
    static func validate(email:String?) -> String? {
        guard let emailAddress = email, !emailAddress.trimed().isEmpty else { return "registration-validation-message-mail".translated}
       
        do {
            if try NSRegularExpression(pattern: "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$", options: .caseInsensitive).firstMatch(in: emailAddress, options: [], range: NSRange(location: 0, length: emailAddress.count)) == nil {
                return "registration-validation-message-valid-mail".translated
            }
        } catch {
            return "registration-validation-message-valid-mail".translated
        }
        
        return nil
    }
    
    static func validate(password:String?) -> String? {
        guard let passwordT = password, !passwordT.trimed().isEmpty else { return "registration-validation-message-password".translated }
        let commonError = "Password must be atleast %@ to %@ characters long an include 1 uppercase and 1 lowercase character, 1 number, and 1 special character (!@#$%*__.). Passwords are case sensitive.".formatedSring(args: [String(SMValidator.minPasswordLimit), String(SMValidator.maxPasswordLimit)])
        
        if passwordT.count < SMValidator.minPasswordLimit {
            return commonError
        }
        
        if passwordT.count > SMValidator.maxPasswordLimit {
            return commonError
        }
        
        let capRes = NSPredicate(format:"SELF MATCHES %@", ".*[A-Z]+.*").evaluate(with: passwordT)
        let smallRes = NSPredicate(format:"SELF MATCHES %@", ".*[a-z]+.*").evaluate(with: passwordT)
        let numericRes = NSPredicate(format:"SELF MATCHES %@", ".*[0-9]+.*").evaluate(with: passwordT)
        let specialRes = NSPredicate(format:"SELF MATCHES %@", ".*[!@#$*_.]+.*").evaluate(with: passwordT)
        if capRes == false ||
            smallRes == false ||
            numericRes == false ||
            specialRes == false {
            return commonError
        }
        
        let validRegex = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$*_.]).{\(SMValidator.minPasswordLimit),\(SMValidator.maxPasswordLimit)}$"
        if try! NSRegularExpression(pattern: validRegex, options: .caseInsensitive).firstMatch(in: passwordT, options: [], range: NSRange(location: 0, length: passwordT.count)) == nil {
            return commonError
        }
        return nil
    }
    
    /// Retruns true if value is empty or nil otherwise false
    static func isEmptyString(_ value:String?) -> Bool {
        if value == nil || value?.trimed().isEmpty == true{
            return true
        }
        return false
    }
    
    static func progress(forPassword password:String?) -> Float {
        let capRes = NSPredicate(format:"SELF MATCHES %@", ".*[A-Z]+.*").evaluate(with: password)
        let smallRes = NSPredicate(format:"SELF MATCHES %@", ".*[a-z]+.*").evaluate(with: password)
        let numericRes = NSPredicate(format:"SELF MATCHES %@", ".*[0-9]+.*").evaluate(with: password)
//        let specialRes = NSPredicate(format:"SELF MATCHES %@", ".*[!@#$*_.]+.*").evaluate(with: password)
        let specialRes =  (password?.range(of: ".*[^A-Za-z0-9].*", options: .regularExpression) != nil)
        var totalCredit = 0
        if capRes { totalCredit += 1}
        if smallRes { totalCredit += 1}
        if numericRes { totalCredit += 1}
        if specialRes { totalCredit += 1}
        
        return Float(totalCredit)*0.25
    }
}

// Extension NSNumber
extension NSNumber {
    func formatedDecimal(locale:String = "cy_GB") -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: locale)
        return formatter.string(from: self) ?? self.stringValue
    }
}
