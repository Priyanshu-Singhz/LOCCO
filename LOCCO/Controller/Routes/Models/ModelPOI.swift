//
//  ModelPOI.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 21/02/24.
//

import Foundation

struct ModelPOI: Codable {
    let location: Location
    let triggerPoints: [TriggerPoint]
    let createdAt, description, id, name: String?
    let type: String
    
    var formatedDescription:String {
        if !SMValidator.isEmptyString(description) {
            return type + "(\(description!))"
        }
        return type
    }
}

// MARK: - Location
struct Location: Codable {
    var lat: Double? = nil
    var lng: Double? = nil
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            self.lat = try container.decodeIfPresent(Double.self, forKey: .lat)
            self.lng = try container.decodeIfPresent(Double.self, forKey: .lng)
        } catch {
            print("[ModelPOI] Location error", error)
        }
    }
}

// MARK: - TriggerPoint
struct TriggerPoint: Codable {
    let coordinate: Location
    let audio: String?
}
