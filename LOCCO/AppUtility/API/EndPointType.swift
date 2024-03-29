//
//  EndPointType.swift
//  VetPrompter
//
//  Created by Sudhir on 22/06/23.
//

import Alamofire
import Foundation

/// A protocol that define all the properties which helps to do network requests
///
/// Its only return values not storing anything. You can check
protocol SMEndPointType {
    
    // MARK: - Vars & Lets
    
    /// Retruns api base url
    var baseURL: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var url: URL { get }
    var encoding: ParameterEncoding { get }
    var version: String { get }
    
}

/// Environment which you wants to add. This options are used to identify base url of server.
///
/// Before start you have to assign value for each environment you have added.
///
/// You can add or remove it according your requirement.
enum NetworkEnvironment {
    case dev
    case staging
    case production
}

/// Helps to list down all API cases under this enum so you can identify and retrun value accordingly.
///
/// Each case indcates single api details which includes Base URL, Version, Path, Http Method, headers, combine url and encoding.
/// - You can provide enpoint specific value using declaring all case here and use it
/// - Provide none option as defualt value.
/// - Extension which  is resposible for retrun all related values for each case.
enum SMEndpointItem {
    case getPOI
    case login
    case register
    case confirmRegister
    case accessToken
    case refreshToken
    case forgotPassword
    case confirmForgotPassword
    case resendCode
    case googleLogin
    case appleLogin
    case logout
    case translations
    case none
}


// MARK: - Extensions

extension SMEndpointItem: SMEndPointType {
    /// returns base url according environment. Please update it according your requirements
    var baseURL: String {
        switch SMAPIManager.networkEnviroment {
            case .dev: return "https://n5vd2rg187.execute-api.eu-central-1.amazonaws.com/staging"
            case .staging: return "https://n5vd2rg187.execute-api.eu-central-1.amazonaws.com/staging"
            case .production: return "https://n5vd2rg187.execute-api.eu-central-1.amazonaws.com/staging"
        }
    }
    /// Returns version of API
    var version: String {
        return "" //"/v1"
    }
    
    /// Returns path/enpoint of API
    var path: String {
        switch self {
        case .getPOI: return "/pois"
        case .login: return "/auth/login"
        case .register: return "/auth/register"
        case .confirmRegister: return "/auth/confirm-register"
        case .accessToken: return "/auth/update-access-token"
        case .refreshToken: return "/auth/update-refresh-token"
        case .forgotPassword: return "/auth/forgot-password"
        case .confirmForgotPassword: return "/auth/confirm-forgot-password"
        case .resendCode: return "/auth/send-validation-code"
        case .googleLogin: return "/auth/login/google"
        case .appleLogin: return "/auth/login/apple"
        case .logout: return "/auth/logout"
        case .none: return ""
        case .translations: return "/translations"
        }
    }
    
    /// Returns request http method. IT should be according your API configuration
    var httpMethod: HTTPMethod {
        switch self {
        case .getPOI, .translations:
            return .get
        default:
            return .post
        }
    }
    /// Returns header values of API
    var headers: HTTPHeaders? {
        var header = HTTPHeaders()
        header.add(.accept("application/json"))
        //Set Token
        //header.add(.authorization(bearerToken: "token"))
        return header
    }
    
    /// Returns full url of API which includes base url + version + endpoint
    var url: URL {
        switch self {
        default:
            return URL(string: self.baseURL + self.version + self.path)!
        }
    }
    /// Returns encoding of request. Defualt value is JSONEncoding.default
    var encoding: ParameterEncoding {
        switch self {
        case .getPOI:
            return URLEncoding.default
        case .none:
            return JSONEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
}
