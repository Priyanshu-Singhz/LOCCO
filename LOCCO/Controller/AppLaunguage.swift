//
//  AppLaunguage.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 14/02/24.
//

import Foundation

class AppLaunguage {
    static let shared = AppLaunguage()
    private var allTranslations:[ModelLanguages] = []
    
    var currentLanguage: String {
        let appleLanguages = UserDefaults.standard.object(forKey: "AppleLanguages") as? [String] ?? ["en"]
        let prefferedLanguage = appleLanguages[0]
        if prefferedLanguage.contains("-") {
            let array = prefferedLanguage.components(separatedBy: "-")
            return array[0]
        }
        return prefferedLanguage
    }
    
    var currentLanguageName:String {
        let local = Locale(identifier: "en")
        return local.localizedString(forIdentifier: currentLanguage) ?? "-"
    }
    
    
    //MARK: - Helper
    func translation(_ text:String) -> String {
        let result = allTranslations.first(where: {$0.id == text})
        if currentLanguage == "de" {
            return result?.de ?? text
        }
        return result?.en ?? text
    }
    /// Sets the desired language of the ones you have.
    /// If this function is not called it will use the default OS language.
    /// If the language does not exists y returns the default OS language.
    func setLanguage(_ languageCode:String) {
        var appleLanguages = UserDefaults.standard.object(forKey: "AppleLanguages") as! [String]
        appleLanguages.remove(at: 0)
        appleLanguages.insert(languageCode, at: 0)
        UserDefaults.standard.set(appleLanguages, forKey: "AppleLanguages")
        UserDefaults.standard.synchronize() //needs restart
    }
    //MARK: - Private
    
    
    //MARK: - API
    ///Loads all translations from server
    func loadLanguages(handler: (() -> Void)? = nil) {
        SMAPIManager.shared().request(type: .translations) { responseData, statusCode, error in
            if let resData = responseData {
                do {
                    self.allTranslations = try JSONDecoder().decode([ModelLanguages].self, from: resData)
                } catch {
                    appPrint("[AppLaunguage] loadLanguages decode error: ", error)
                }
            }
            handler?()
        }
    }
}

extension String {
    var translated: String {
        return AppLaunguage.shared.translation(self)
    }
}

struct ModelLanguages: Codable {
    let id:String
    let de:String
    let en:String
}
