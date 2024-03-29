//
//  SMLocationManager.swift
//  SilvaTree
//
//  Created by ZTLAB13 on 28/07/20.
//  Copyright © 2020 ZTLAB13. All rights reserved.
//

import UIKit
import CoreLocation

class SMLocationManager: NSObject, CLLocationManagerDelegate {
    typealias completionAuthorizationdidChange = (Bool) -> Void
    
    fileprivate let locationManager = CLLocationManager()
    var locationAuthorizationStatus:CLAuthorizationStatus = .notDetermined
    
    var completionAuthorizationDidChanged:completionAuthorizationdidChange!
    var handleLocationDidChanged:(() -> ())? = nil
    
    ///  Returns current location service enable or not
    var isLocationDisabled:Bool {
        let isdisabled = (self.locationAuthorizationStatus == .denied || self.locationAuthorizationStatus == .restricted )
        return isdisabled
    }
    
    //Current Location of user
    var currentLocation = CLLocationCoordinate2D(latitude: 48.1351, longitude: 11.5820) {
        didSet {
            self.handleLocationDidChanged?()
        }
    }
    // MARK:- LifeCycle
    class var shared : SMLocationManager {
        struct Static {
            static let instance : SMLocationManager = SMLocationManager()
        }
        return Static.instance
    }
    
    //MARK: - Helper
    func requestLocation(delegate:UIViewController? = UIApplication.shared.firstKeyWindow?.rootViewController, completion: @escaping completionAuthorizationdidChange) {
        completionAuthorizationDidChanged = completion
        var isOpenScreen = false
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                DispatchQueue.main.async {
                    let status = self.locationManager.authorizationStatus
                    self.locationAuthorizationStatus = status
                    switch status {
                    case .notDetermined:
                        //open permission screen
                        isOpenScreen = true
                        print("CLAuthorizationStatus:- notDetermined")
                        break
                    case .denied:
                        print("CLAuthorizationStatus:- Denied")
                        break
                    case .restricted:
                        print("CLAuthorizationStatus:- restricted")
                        break
                    case .authorizedAlways, .authorizedWhenInUse:
                        print("CLAuthorizationStatus:- Access")
                        break
                    @unknown default:
                        print("CLAuthorizationStatus:- Unknown")
                        break
                    }
                }
            } else {
                //open location screen
                print("CLAuthorizationStatus:- Not requested yet")
                self.locationAuthorizationStatus = .denied
            }
            
            DispatchQueue.main.async {
                if isOpenScreen {
                    self.requestLocations()
                }else{
                    self.requestLocations()
                    let isAccess = (self.locationAuthorizationStatus == .authorizedAlways || self.locationAuthorizationStatus == .authorizedWhenInUse)
                    self.completionAuthorizationDidChanged?(isAccess)
                }
            }
        }
        
        
    }
    
    //MARK: - Private
    fileprivate func requestLocations() -> Void {
        self.locationManager.requestWhenInUseAuthorization()
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager.startMonitoringSignificantLocationChanges()
                self.locationManager.startUpdatingLocation()
            }
        }
    }
    
    
    fileprivate func showDeniedPopup(_ delegate:UIViewController? = UIApplication.shared.firstKeyWindow?.rootViewController) {
        let alertConfirm = UIAlertController(title: "Location".translated, message:"Your location permissions for the app is currently denied. Please open the settings and allow LOCCO to fetch your location".translated, preferredStyle: .alert)
        let actOk = UIAlertAction(title: "Okay".translated, style: .default) { (finish) in
        }
        let actSettings = UIAlertAction(title: "Settings".translated, style: .default) { (finish) in
            self.openSettings()
        }
        alertConfirm.addAction(actOk)
        alertConfirm.addAction(actSettings)
        delegate?.present(alertConfirm, animated: true, completion: nil)
    }
    
    func openSettings(){
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)") // Prints true
            })
        }
    }
    
    //MARK: - Location Delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue = locations.first?.coordinate else { return }
        currentLocation = locValue
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint("locationManager:-", error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.locationAuthorizationStatus = status
        requestLocation(completion: self.completionAuthorizationDidChanged)
    }
}
