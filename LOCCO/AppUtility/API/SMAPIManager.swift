//
//  SMAPIManager.swift
//  VetPrompter
//
//  Created by Sudhir on 22/06/23.
//

import Foundation
import Alamofire
import UIKit

enum SMStatusCode: Int {
    case sucess = 200
    case NotAuthorized = 401
    case UserNotConfirmedException = 403
    case SignInFailed = 500
    case CodeMismatchException = 422
}

struct SMRequest {
    var request:SMEndpointItem
    var parameter:Parameters?
    var token:String?
    var completionBlock:SMAPIManager.SMResponse
    
    init(request: SMEndpointItem, parameter: Parameters? = nil, token: String?, completionBlock: @escaping SMAPIManager.SMResponse) {
        self.request = request
        self.parameter = parameter
        self.token = token
        self.completionBlock = completionBlock
    }
}

class SMAPIManager {
    typealias SMResponse = (_ responseData:Data?, _ statusCode:Int, _ error:String?) -> Void
    
    // MARK: - Vars & Lets
    /// Object to store Alamofire Session
    private let sessionManager: Session
    
    /// Environment of server which you want to use. If not set please check and update NetworkEnvironment
    static let networkEnviroment: NetworkEnvironment = .dev
    
    // MARK: - Vars & Lets
    /// Constant that store object of SMAPIManager. Its static so initialise first time only
    private static var sharedApiManager: SMAPIManager = {
        let apiManager = SMAPIManager(sessionManager: Session())
        return apiManager
    }()
    
    private var isUpdatingToken:Bool = false
    private var arrPendingRequest:[SMRequest] = []
    
    // MARK: - Accessors
    /// Constant that store object of SMAPIManager. Its static so initialise first time only
    class func shared() -> SMAPIManager {
        return sharedApiManager
    }
    
    // MARK: - Initialization
    /// Custom Init with Session
    private init(sessionManager: Session) {
        self.sessionManager = sessionManager
    }
    
    //MARK: - Response Decodable

    /// This method helps to network request and returns Decodable response
    /// - Parameters:
    ///     - oftype: it should be Decodable (Codable model) in which you wnt to convert response
    ///     - endpoint: it should be SMEndpointItem. Please configure it before use if still not done that
    ///     - params: Parameters which you want to pass within request. It is options and default value is nil
    ///     - token: pass this if you want to manually use header token. It will be added as Authorization header
    ///     - handler: it returns response as Decodable and error if exist and bool

    func requestDecodable<T:Decodable>(oftype:T.Type, endpoint: SMEndpointItem, params: Parameters? = nil, token:String? = nil, handler: @escaping ((_ result:T?, _ error: String?, _ isSuccess:Bool)->())) {
        
        if let p = params {
            debugPrint("[APIManager] url: [\(endpoint.httpMethod.rawValue)]", endpoint.url.absoluteString, "Parameters: ",p as NSDictionary)
        } else {
            debugPrint("[APIManager] url: [\(endpoint.httpMethod.rawValue)] ", endpoint.url.absoluteString)
        }
        
        var headers = endpoint.headers ?? [:]
        //Add token if service without creating session/login
        if let tok = token {
            headers.add(.authorization(tok))
        }
        
        self.sessionManager.request(endpoint.url,
                                    method:endpoint.httpMethod,
                                    parameters: params,
                                    encoding: endpoint.encoding,
                                    headers: endpoint.headers).validate().responseData { response in
            DispatchQueue.main.async {
                switch response.result {
                case .success(let mydata):
                    let decoder = JSONDecoder()
                    do {
                        let dict = try JSONSerialization.jsonObject(with: mydata, options: []) as? [String: Any]
                        debugPrint("[APIManager] result: ", dict)
                        
                        let validateResult = self.validate(result: dict ?? [:])
                        let result = try decoder.decode(oftype, from: mydata)
                        handler(result, validateResult.message, validateResult.success)
                    } catch {
                        debugPrint("[APIManager] error: ", error)
                        handler(nil, error.localizedDescription, false)
                    }
                    break
                case .failure(let error):
                    debugPrint("[APIManager] failure error: ", error)
                    handler(nil, error.localizedDescription, false)
                    break
                }
                
            }
        }
    }
    
    /// This method helps to multipart network request and returns Decodable response
    /// - Parameters:
    ///     - oftype: it should be Decodable (Codable model) in which you wnt to convert response
    ///     - endpoint: it should be SMEndpointItem. Please configure it before use if still not done that
    ///     - params: Parameters which you want to pass within request. It is options and default value is nil
    ///     - token: pass this if you want to manually use header token. It will be added as Authorization header
    ///     - handler: it returns response as Decodable and error if exist and bool
    func requestMultipartDecodable<T:Decodable>(oftype:T.Type, endpoint: SMEndpointItem, params: Parameters? = nil, token:String? = nil, handler: @escaping ((_ result:T?, _ error: String?, _ isSuccess:Bool)->())) {
        
        if let p = params {
            debugPrint("[APIManager] url: [\(endpoint.httpMethod.rawValue)]", endpoint.url.absoluteString, "Parameters: ",p as NSDictionary)
        } else {
            debugPrint("[APIManager] url: [\(endpoint.httpMethod.rawValue)] ", endpoint.url.absoluteString)
        }
        
        var headers = endpoint.headers ?? [:]
        //Add token if service without creating session/login
        if let tok = token {
            headers.add(.authorization(tok))
        }
        headers.add(name: "Content-type", value: "multipart/form-data")
        
        let uploadRequest = self.sessionManager.upload(multipartFormData: { formData in
            //Build formdata parameters
            for (key, value) in params ?? [:] {
                if  let image = value as? UIImage,
                    let imgData = image.jpegData(compressionQuality: 1.0) {
                    formData.append(imgData, withName: key, fileName: "\(key).jpeg", mimeType: "image/jpeg")
                }
//                else if let imageInfo = value as? ImagePickerManager.SMImageInfo,
//                         let imgData = imageInfo.image.jpegData(compressionQuality: 1.0) {
//                    formData.append(imgData, withName: key, fileName: imageInfo.name, mimeType: imageInfo.contentType)
//                }
                else  if let fileURL = value as? URL{
                    formData.append(fileURL, withName: key)
                }
                else if let strVal = value as? String, let paramData = strVal.data(using: .utf8) {
                    formData.append(paramData, withName: key)
                }
                else if let number = value as? NSNumber, let paramData = "\(number)".data(using: .utf8) {
                    formData.append(paramData, withName: key)
                }
            }
        }, to: endpoint.url, method: endpoint.httpMethod, headers: headers)
        
        
        uploadRequest.uploadProgress { progress in
            debugPrint("[APIManager] uploadProgress", progress.fractionCompleted)
        }
        
        uploadRequest.responseData { response in
            
            switch response.result {
            case .success(let mydata):
                let decoder = JSONDecoder()
                do {
                    let dict = try JSONSerialization.jsonObject(with: mydata, options: []) as? [String: Any]
                    debugPrint("[APIManager] result: ", dict)
                    
                    let validateResult = self.validate(result: dict ?? [:])
                    let result = try decoder.decode(oftype, from: mydata)
                    handler(result, validateResult.message, validateResult.success)
                } catch {
                    debugPrint("[APIManager] error: ", error)
                    handler(nil, error.localizedDescription, false)
                }
                break
            case .failure(let error):
                debugPrint("[APIManager] failure error: ", error)
                handler(nil, error.localizedDescription, false)
                break
            }
            
        }
    }
    
    //MARK: - Response Any
    
    /// This method helps to  network request and returns json object in response.
    /// - Parameters:
    ///     - oftype: it should be Decodable (Codable model) in which you wnt to convert response
    ///     - endpoint: it should be SMEndpointItem. Please configure it before use if still not done that
    ///     - params: Parameters which you want to pass within request. It is options and default value is nil
    ///     - token: pass this if you want to manually use header token. It will be added as Authorization header
    ///     - handler: it returns response as Decodable and error if exist and bool
    func request(type: SMEndpointItem, params: Parameters? = nil, token:String? = nil, handler: @escaping SMResponse){
        
        if let p = params {
            debugPrint("[APIManager] url: [\(type.httpMethod.rawValue)]", type.url.absoluteString, "Parameters: ",p as NSDictionary)
        } else {
            debugPrint("[APIManager] url: [\(type.httpMethod.rawValue)] ", type.url.absoluteString)
        }
        
        var headers = type.headers ?? [:]
        //Add token if service without creating session/login
        if let tok = token {
            headers.add(.authorization(tok))
        }
        
        if isUpdatingToken {
            // add request in queue while token is refreshing
            arrPendingRequest.append(SMRequest(request: type, parameter: params, token: token, completionBlock: handler))
            appPrint("[APIManager] appending request:- ", type.url.absoluteString)
        } else {
            //request data  from server
            self.sessionManager.request(type.url, method: type.httpMethod, parameters: params, encoding: type.encoding, headers: headers).validate(statusCode: 200...500).responseData { response in
                DispatchQueue.main.async {
                    
                    let statusCode = response.response?.statusCode ?? 0
                    if statusCode == SMStatusCode.NotAuthorized.rawValue{
                        //Add curent request to queue
                        self.arrPendingRequest.append(SMRequest(request: type, parameter: params, token: token, completionBlock: handler))
                        self.updateAccessToken()
                    } else {
                        switch response.result {
                        case .success(let mydata):
                            handler(mydata, statusCode, nil)
                            debugPrint("[APIManager] success with statusCode: ", statusCode)
                            break
                        case .failure(let error):
                            debugPrint("[APIManager] failure error: ", error)
                            handler(nil, statusCode, error.localizedDescription)
                            break
                        }
                    }
                }
            }
        }
    }
   /// This method update device token and hadle
    func updateAccessToken() {
        if UserSession.shared.isPersistantLoggedIn {
            //refresh access token
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.isUpdatingToken = true
            })
            
            UserSession.shared.updateAccessToken { isSuccess, message in
                self.isUpdatingToken = false
                appPrint("[SMAPIManager] updateAccessToken resposne: ", isSuccess)
                if isSuccess {
                    //Recall all apis
                    for request in self.arrPendingRequest {
                        self.request(type: request.request, params: request.parameter, token: request.token, handler: request.completionBlock)
                    }
                    self.arrPendingRequest.removeAll()
                } else {
                    //Force Logout
                    self.clearAndLogOut()
                }
            }
        } else {
            //No token require for request
            appPrint("[SMAPIManager] Start refreshing but user is not logged in")
            clearAndLogOut()
        }
    }
}

extension SMAPIManager {
    //MARK: - Helper Method
    ///  Validate response according server response
    private func validate(result: Dictionary<String, Any>) -> (success:Bool, message:String?) {
        
        let msg = result["response_msg"] as? String
        
        if let status = result["status"]  {
            if ((status as? Bool) == true) || ((status as? Int) == 1) || ((status as? String) == "success") {
                return(true, msg)
            }
            else {
                return(false, msg)
            }
        }
        return(false, nil)
    }
    
    
    /// Helps to decode status code and find related message from response
    /// - Parameters:
    ///     - code:  status code recived in response
    ///     - data: response data
    /// - Returns: returns bool as succes or failure and string message if exist

    static func decodeError(code:Int, data:Data?) -> (success:Bool, message:String?) {
        var message:String? = nil
        
        if let reData = data{
            if let responseMsg = String(data: reData, encoding: .utf8) {
                message = responseMsg
            }
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: reData)
                if let msg =  (jsonObject as? [String:Any])?["message"] as? String, !SMValidator.isEmptyString(msg)  {
                    message = msg
                }
                appPrint("[SMAPIManager] Response: ", jsonObject)
            } catch {
                appPrint("[SMAPIManager] decodeError: ", error)
            }
        }
        
        
        switch code {
        case 200...201 :
            return(true, message)
        default:
            return(false, message)
        }
    }
    
    func clearAndLogOut() {
        UserSession.shared.clear()
    }
}
