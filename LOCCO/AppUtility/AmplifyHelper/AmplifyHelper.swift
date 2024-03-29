//
//  AmplifyHelper.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 28/02/24.
//

//import Foundation
//import Amplify
//
//struct SMResponse {
//    /// Returns true if operation is success in any other case it will be false
//    let isSuccess:Bool
//    /// Contains localised description of error if any other wise it will be nill
//    var error:String? = nil
//    /// If true, user must have to verify his email other wise false
//    var isNeedToVerify:Bool = false
//    /// User must have to login again if this variable is true
//    var isAuthError:Bool = false
//}
//
//class AmplifyHelper {
//    
//    /// Register user to Cognito using Amplify.
//    /// - Parameters:
//    ///     - credential: it should be ModelLogin. must contains value of email, password and name
//    /// - Returns: it retruns SMResponse genral response to check request is gets success or not
//    static func signUp(credential:ModelLogin) async -> SMResponse {
//        let userAttributes = [AuthUserAttribute(.email, value: credential.email),
//                              AuthUserAttribute(.name, value: credential.name)]
//        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
//        do {
//            let signUpResult = try await Amplify.Auth.signUp(
//                username: credential.email,
//                password: credential.password,
//                options: options
//            )
//            
//            if case let .confirmUser(deliveryDetails, _, userId) = signUpResult.nextStep {
//                appPrint("[AmplifyHelper] SignUp response \(String(describing: deliveryDetails)) for userId: \(String(describing: userId))")
//                return SMResponse(isSuccess: false, error: "Please verify your email", isNeedToVerify: true)
//            } else {
//                appPrint("[AmplifyHelper] SignUp Complete")
//                return SMResponse(isSuccess: true)
//            }
//        } catch let error as AuthError {
//            appPrint("[AmplifyHelper]  An error occurred while registering a user : \(error.localizedDescription)")
//            return SMResponse(isSuccess: false, error: error.localizedDescription, isAuthError: true)
//        } catch {
//            appPrint("[AmplifyHelper] SignUp Unexpected error: \(error)")
//            return SMResponse(isSuccess: false, error: error.localizedDescription)
//        }
//    }
//    
//    /// Confirms the signUp operation.
//    /// - Parameters:
//    ///     - email:  Username used that was used to signUp.
//    ///     - code: Confirmation code received to the user.
//    static func confirmSignUp(email: String, code: String) async -> SMResponse {
//        do {
//            let confirmSignUpResult = try await Amplify.Auth.confirmSignUp(
//                for: email,
//                confirmationCode: code
//            )
//            appPrint("[AmplifyHelper]  Confirm sign up result completed: \(confirmSignUpResult.isSignUpComplete)")
//            return SMResponse(isSuccess:confirmSignUpResult.isSignUpComplete)
//        } catch let error as AuthError {
//            appPrint("[AmplifyHelper]  An error occurred while confirming sign up \(error)")
//            return SMResponse(isSuccess:false, error: error.localizedDescription, isAuthError: true)
//        } catch {
//            print("[AmplifyHelper]  Unexpected error: \(error)")
//            return SMResponse(isSuccess:false, error: error.localizedDescription)
//        }
//    }
//    
//    /// Login user to Cognito using Amplify.
//    /// - Parameters:
//    ///     - credential: it should be ModelLogin. must contains value of email and password
//    /// - Returns: it retruns SMResponse genral response to check request is gets success or not
//    static func signIn(credential:ModelLogin) async -> SMResponse {
//        do {
//            let signInResult = try await Amplify.Auth.signIn(
//                username: credential.email,
//                password: credential.password
//                )
//            if case let .confirmSignUp(additionalInfo) = signInResult.nextStep {
//                appPrint("[AmplifyHelper] signIn response \(String(describing: additionalInfo))")
//                return SMResponse(isSuccess: false, error: "Please verify your email", isNeedToVerify: true)
//            } else {
//                appPrint("[AmplifyHelper] Sign in succeeded")
//                return SMResponse(isSuccess:true)
//            }
//        } catch let error as AuthError {
//            appPrint("[AmplifyHelper] Sign in failed \(error)")
//            return SMResponse(isSuccess:false, error: error.localizedDescription, isAuthError: true)
//        } catch {
//            appPrint("[AmplifyHelper] Unexpected error: \(error)")
//            return SMResponse(isSuccess:false, error: error.localizedDescription)
//        }
//    }
//}
