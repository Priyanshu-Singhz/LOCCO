//
//  ViewModelGameProfile.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 22/02/24.
//

import Foundation
import UIKit

class ViewModelGameProfile {
    //MARK: - Properties
    var arrayMyMissionData:[MyMissionModel] = []
    //Initialize Method
    init(){
        createMyMissionData()
    }
    
    // Create the Mission Data
    fileprivate func createMyMissionData(){
        arrayMyMissionData.removeAll()
        arrayMyMissionData.append(MyMissionModel(image: UIImage(named: "ic_menu_startShine"), title: "SPOTLIGHTS", description: "Listen to the daily changing Spotlights on your homescreen.", points: 50, score: 25, scoreTotal: 30, isCompleted: false))
        arrayMyMissionData.append(MyMissionModel(image: UIImage(named: "celebration"), title: "COMMUNITY BOOSTERS", description: "Contribute to the community by sharing your location when you see something exciting.", points: 100, score: 0, scoreTotal: 0, isCompleted: true))
        arrayMyMissionData.append(MyMissionModel(image: UIImage(named: "ic_menu_tunnel"), title: "DISCOVERIES",description: "Collect discoveries by triggering and listening to audios on your journeys.", points: 25, score: 66, scoreTotal: 30, isCompleted: true))
        arrayMyMissionData.append(MyMissionModel(image: UIImage(named: "Rocket"), title: "TRIP STARTER",description: "Start LOCCO and listen to at least one discovery on your journey.", points: 50, score: 25, scoreTotal: 10, isCompleted: true))
    }
}
