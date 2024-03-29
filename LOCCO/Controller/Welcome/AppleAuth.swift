//
//  AppleAuth.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 12/03/24.
//

import Foundation
import AuthenticationServices

class AppleAuth: NSObject {
    typealias handlerAppleAuth = ((_ response:ModelLogin?, _ message:String) -> ())
    
    static let shared:AppleAuth = AppleAuth()
    
    ///Executes on success or error occured during authentication
    private var completionHandler:handlerAppleAuth? = nil
    
    /// Helps to authenticate using apple
    func signInWithApple(handler: @escaping handlerAppleAuth) {
        self.completionHandler = handler
        let provider = ASAuthorizationAppleIDProvider()
        let request =  provider.createRequest()
        request.requestedScopes = [.fullName,.email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
}


//MARK: - Apple Reponse methods
extension AppleAuth: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        appPrint("[WelcomePageVC] Error",error)
        self.completionHandler?(nil, error.localizedDescription)
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        appPrint("[AppleAuth] result", authorization.credential)
        if let response = authorization.credential as? ASAuthorizationAppleIDCredential{
            
            guard let appleIDToken = response.identityToken else {
                print("[AppleAuth] Unable to fetch identity token")
                self.completionHandler?(nil, "Invalid id Token".translated)
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("[AppleAuth] Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                self.completionHandler?(nil, "Unable to serialize token string from data".translated)
                return
            }

            var credential = ModelLogin()
            credential.socialID = idTokenString
            credential.givenName = response.fullName?.givenName ?? "NF"
            credential.familyName = response.fullName?.familyName ?? "NF"
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.completionHandler?(credential, "")
            })
        } else {
            self.completionHandler?(nil, "Something went wrong!".translated)
        }
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.firstKeyWindow!
    }
}

