//
//  VMDrivingOnboarding.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 11/03/24.
//

import Foundation
import UIKit

struct ModelDrivingOnboarding {
    let id:String
    let title:String?
    let description:String?
    let image:UIImage?
    var othertext:String? = nil
    var otherImage:UIImage? = nil
    
    init(ide:String, title: String?, description: String?, image: UIImage?, othertext: String? = nil, otherImage: UIImage? = nil) {
        self.id = ide
        self.title = title
        self.description = description
        self.image = image
        self.othertext = othertext
        self.otherImage = otherImage
    }
}

class VMDrivingOnboarding {
    ///get or set Current page of animation
    var currentPage:Int = 0
    /// Stores information about list of animations
    var arrTutorial:[ModelDrivingOnboarding] = []
    
    init() {
        //create list of animaions
        arrTutorial.append(ModelDrivingOnboarding(ide: "nextDiscovery", title: "Next discovery", description: "Here you can see the street, where the next discovery - i.e. an audio - is placed. You can only listen to it if you are actually driving by.", image: nil, othertext: "Swipe left\nto continue", otherImage: UIImage(named: "image_ob_swipe")))

        arrTutorial.append(ModelDrivingOnboarding(ide: "progress", title: "Distance", description: "This circle always shows your current distance to the next discovery.", image: UIImage(named: "image_ob_progressRing")))
        
        arrTutorial.append(ModelDrivingOnboarding(ide: "requestAudio", title: "Contribute to the community!", description: "If you see something exciting - let us know! We will check your submission and publish a corresponding audio.", image: UIImage(named: "image_ob_request")))
        
        arrTutorial.append(ModelDrivingOnboarding(ide: "progress", title: "Only 1 km left!", description: "You're almost there and the audio will play .", image: UIImage(named: "image_ob_progressRing")))
        
        arrTutorial.append(ModelDrivingOnboarding(ide: "progress", title: "Finally!", description: "The audio now triggers automatically - regardless of whether you have another app open.", image: UIImage(named: "image_ob_progressRing")))
        
        arrTutorial.append(ModelDrivingOnboarding(ide: "audioPlayer", title: "Enjoy the audio!", description: nil, image: UIImage(named: "image_ob_player")))
        
        arrTutorial.append(ModelDrivingOnboarding(ide: "addStopOver", title: "Wow, I want to go there!", description: "Get the directions to your discovery!", image: UIImage(named: "image_ob_Route")))

    }
}
