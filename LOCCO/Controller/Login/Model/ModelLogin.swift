//
//  ModelLogin.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 05/03/24.
//

import Foundation

struct ModelLoginResponse: Codable {
    let message:String?
    var statusCode:Int? = 0
    var data:SessionInfo? = nil
    var dataString:String? = nil
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.message = try container.decodeIfPresent(String.self, forKey: .message)
        self.statusCode = try container.decodeIfPresent(Int.self, forKey: .statusCode)
        self.data = try container.decodeIfPresent(SessionInfo.self, forKey: .data)
        do {
            self.dataString = try container.decodeIfPresent(String.self, forKey: .data)
        } catch {
            
        }
    }
    
    init(statusCode:Int) {
        self.message = nil
        self.dataString = nil
        self.statusCode = statusCode
    }
}

struct SessionInfo: Codable {
    var accessToken:String
    var refreshToken:String
    let expiresIn:TimeInterval
    let emailVerified:Bool?
}


