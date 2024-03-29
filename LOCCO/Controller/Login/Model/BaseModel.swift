//
//  BaseModel.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 05/03/24.
//

import Foundation

struct BaseModel: Codable {
    let message:String?
    var data:String?
    var statusCode:Int?
}


struct ModelAccessToken: Codable {
    struct RTData:Codable {
        let accessToken:String
    }
    
    let message:String?
    let data:RTData?
}

struct ModelRefreshToken: Codable {
    struct ATData:Codable {
        let refreshToken:String
    }
    
    let message:String?
    let data:ATData?
}
