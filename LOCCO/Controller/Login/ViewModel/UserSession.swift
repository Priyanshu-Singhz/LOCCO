//
//  UserSession.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 05/03/24.
//

import Foundation
import UIKit

class UserSession {
    static let shared:UserSession = UserSession()
    
    var loginInfo:SessionInfo? = nil
    
    ///Return true if persisistant details available
    var isPersistantLoggedIn:Bool {
        if loginInfo == nil { _ = self.loadSession() }
        return loginInfo != nil
    }
    
    var userEmail:String? {
        set {
            UserDefaults.appSetObject(newValue ?? "", forKey: "userEmail")
        }
        get {
            return UserDefaults.standard.string(forKey: "userEmail")
        }
    }
    var isShownDrivingOnboarding:Bool {
        get {
            return UserDefaults.standard.bool(forKey: AppUDK.isShownDrivingOnboarding)
        }
        set {
            UserDefaults.appSetObject(newValue, forKey: AppUDK.isShownDrivingOnboarding)
        }
    }
    
    
    
    //MARK: - Helper
    ///  save given session in local
    func saveSession(session:SessionInfo?){
        do {
            let jsonEncoder = try JSONEncoder().encode(session)
            UserDefaults.appSetObject(jsonEncoder, forKey: AppUDK.loginInfo)
        } catch {
            appPrint("[UserSession] saveSession error: ",error)
        }
        loginInfo = session
    }
    
    /// Return user session details if user alerady logged in
    func loadSession() -> SessionInfo? {
        if let sessionData = UserDefaults.standard.data(forKey: AppUDK.loginInfo) {
            do{
                loginInfo =  try JSONDecoder().decode(SessionInfo.self, from: sessionData)
            } catch {
                appPrint("[UserSession] loadSession error: ",error)

            }
        }
        return loginInfo
    }
    
    //Clear all data from local
    func clear()  {
        self.loginInfo = nil
        UserDefaults.appRemoveObjectForKey(AppUDK.loginInfo)
        UIApplication.appDelegate?.switchToWelCome()
    }
    
    //MARK: - API
    /// Retrieve accesstoken from server
    func updateAccessToken(completion:@escaping ((_ isSucess:Bool, _ message: String?) -> ())) {
        if let refreshToken = loginInfo?.refreshToken {
            var parameter:[String:Any] = [:]
            parameter["refreshToken"] = refreshToken
            SMAPIManager.shared().request(type: .accessToken, params: parameter) { responseData, statusCode, error in
                let decodedResult = SMAPIManager.decodeError(code: statusCode, data: responseData)
                if let resData = responseData {
                    do {
                        let resultModel = try JSONDecoder().decode(ModelAccessToken.self, from: resData)
                        self.loginInfo?.accessToken = resultModel.data?.accessToken ?? ""
                        self.saveSession(session: self.loginInfo)
                    } catch {
                        appPrint("[UserSession] updateAccessToken decode error: ", error)
                    }
                }
                completion(decodedResult.success, decodedResult.message)
            }
        } else {
            self.clear()
            completion(false, "Session Expired!".translated)
            appPrint("[UserSession] updateAccessToken refresh token not found")
        }
    }
    
    func logoutUser(completion: ((_ isSucess:Bool, _ message: String?) -> ())? = nil) {
        SMAPIManager.shared().request(type: .logout, params: ["email":self.userEmail ?? ""]) { responseData, statusCode, error in
            let decodedResult = SMAPIManager.decodeError(code: statusCode, data: responseData)
            completion?(decodedResult.success, decodedResult.message)
            self.clear()
        }
    }

}

//MARK: - Private
extension UserSession {
}
