//
//  ViewModelOnboarding.swift
//  Onboarding
//
//  Created by Zignuts Technolab on 12/02/24.
//

import Foundation
struct ModelOnboardInfo {
    var icon:String
    var title:String
    var description:String
    var videoUrl:String
}

class ViewModelOnboarding {
    /// List of onboarding screens
    var arrOnBoardData:[ModelOnboardInfo] = []
    
    init() {
        createData()
    }
    
    /// Generates onboarding data
    fileprivate func createData() {
        arrOnBoardData.removeAll()
        arrOnBoardData.append(ModelOnboardInfo(icon: "ic_onboard1", title: "initial_slider_discover_title", description: "initial_slider_discover_subtitle", videoUrl: "onboard_video1"))
        arrOnBoardData.append(ModelOnboardInfo(icon: "ic_onboard2", title: "initial_slider_listen_title", description: "initial_slider_listen_subtitle", videoUrl: "onboard_video2"))
        arrOnBoardData.append(ModelOnboardInfo(icon: "ic_onboard3", title: "initial_slider_audios_title", description: "initial_slider_audios_subtitle", videoUrl: "onboard_video3"))
    }
}
