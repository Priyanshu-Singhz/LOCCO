//
//  MyMissionModel.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 22/02/24.
//

import UIKit

struct MyMissionModel {
    var image: UIImage?
    var title, description: String
    var points, score, scoreTotal: Int
    var isCompleted: Bool
    var isExpanded: Bool
    
    // Initialize the struct with default values
    init(image: UIImage?, title: String, description: String, points: Int, score: Int, scoreTotal: Int, isCompleted: Bool, isExpanded: Bool = false) {
        self.image = image
        self.title = title
        self.description = description
        self.points = points
        self.score = score
        self.scoreTotal = scoreTotal
        self.isCompleted = isCompleted
        self.isExpanded = isExpanded 
    }
}

