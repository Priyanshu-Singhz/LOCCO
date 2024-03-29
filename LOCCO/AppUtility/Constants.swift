//
//  Constants.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 13/02/24.
//

import UIKit
struct AppStoryboard {
    static let main = UIStoryboard(name: "Main", bundle: nil)
    static let home = UIStoryboard(name: "Home", bundle: nil)
    static let driving = UIStoryboard(name: "Driving", bundle: nil)
    static let drivingOnboard = UIStoryboard(name: "DrivingOnboard", bundle: nil)
    
}


struct APPCredentials {
    static let googleAPIKey = "AIzaSyAVPFdEKwbnc_c3jFi9IQehv72cwJbLGfE"
    static let googleClientKey = "618056674391-8ln7ad698n9pdqdptv5vbr1js5rplode.apps.googleusercontent.com"
    static let googleReverseClientKey = "com.googleusercontent.apps.618056674391-8ln7ad698n9pdqdptv5vbr1js5rplode"
}

struct AppUDK {
    static let loginInfo = "myUserLoginInformation"
    static let isShownRouteInfoPopup = "isShownRouteInfoPopup"
    static let isShownDrivingOnboarding = "isShownDrivingOnboarding"
}
