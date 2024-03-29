//
//  ViewModelRoutes.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 21/02/24.
//

import UIKit

class ViewModelRoutes{
    //MARK: - Properties
    var arrPOI:[ModelPOI] = []
    /// Set or get ingo popup state
    static var isInfoPopupShown:Bool {
        get {
            return UserDefaults.standard.bool(forKey: AppUDK.isShownRouteInfoPopup)
        }
        set {
            UserDefaults.appSetObject(newValue, forKey: AppUDK.isShownRouteInfoPopup)
        }
    }
    
    /// Executes when any reponse changes has been made
    var responseChanges:((String?) -> ())? = nil
    
    //Init Method
    init(){
    }
    
    //MARK: - Helper
    /// Loads Point of interest from server
    func loadPOI() {
        SMAPIManager.shared().requestDecodable(oftype: [ModelPOI].self, endpoint: .getPOI) { result, error, isSuccess in
            if error != nil {
                print("error", error!)
                self.responseChanges?(error?.description)
            } else if let response = result {
                self.arrPOI = response
                self.responseChanges?(nil)
                print("result", self.arrPOI.count)
            }
        }
    }
    
}
