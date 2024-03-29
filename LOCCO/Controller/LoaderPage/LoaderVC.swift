//
//  LoaderVC.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 12/02/24.
//

import UIKit
import GoogleMaps

class LoaderVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupGoogleMaps()
        AppLaunguage.shared.loadLanguages {
            if UserSession.shared.isPersistantLoggedIn {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    UIApplication.appDelegate?.switchToHome()
                })
            } else {
                if let onboard = AppStoryboard.main.viewController(OnBoardingVC.self) {
                    self.navigationController?.pushViewController(onboard, animated: false)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    self.navigationController?.appRemoveAllController(LoaderVC.self)
                })
            }
        }
        
    }
    
    func setupGoogleMaps() {
        GMSServices.provideAPIKey(APPCredentials.googleAPIKey)
    }

}
