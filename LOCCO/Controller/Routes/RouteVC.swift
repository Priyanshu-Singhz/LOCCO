//
//  RouteVC.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 21/02/24.
//

import UIKit
import GoogleMaps
class RouteVC: UIViewController {
    
    @IBOutlet weak var navigationBar: SMNavigationBar!
    @IBOutlet weak var mapBaseView: UIView!
    @IBOutlet weak var infoButton: InfoButton!
    @IBOutlet weak var slideToLocco: SlideToActionButton!
    
    private var googleMap: GMSMapView!
    private var vmRoutes = ViewModelRoutes()
    
    //use fade animation instead of defult while go back
    var isFadeAnimation = false
    var isSetLocation:Bool = false
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //Request user location
        SMLocationManager.shared.requestLocation { isSuccess in}
        //Setup UI
        initialSetup()
        //Load POI from server
        vmRoutes.loadPOI()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !ViewModelRoutes.isInfoPopupShown {
            self.infoClicked(self)
        }
    }
    
    // MARK: - Actions
    @IBAction func infoClicked(_ sender: Any) {
        
        var configuration = SMPopupConfigurations()
        configuration.title = "Route"
        configuration.description = "routes_page_info-text".translated
        configuration.button1 = SMButtonConfigurations(idetifier: "close", title: "routes_page_info-close-button", background: UIColor.appSkyBlue,  borderColors: nil, textColor: .appWhite)
        self.infoButton.updateSelectionState(true)
        ViewModelRoutes.isInfoPopupShown = true
        self.showCustomPopup(configuration: configuration) { ide in
            appPrint("Popup close with action: ", ide)
            self.infoButton.updateSelectionState(false)
        }
    }
    
    
    
    // MARK: - Helper
    
    func initialSetup() {
        initiazeMap()
        navigationBar.navigationTitle = "home_routes".translated.uppercased()
        navigationBar.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 32)
        
        //Hanlde back button click
        navigationBar.backButtonClicked = { sender in
            if self.isFadeAnimation {self.navigationController?.fadeAnimation()}
            self.navigationController?.popViewController(animated: !self.isFadeAnimation)
        }
        
        //Handle response changes
        vmRoutes.responseChanges = { error in
            if let errMsg = error {
                self.view.makeToast(errMsg)
            }
            self.plotPOIOnMap()
        }
        
        slideToLocco.handleDidFinish = {
            if let onboard = AppStoryboard.driving.viewController(DrivingModeVC.self) {
                self.navigationController?.pushViewController(onboard, animated: true)
                self.slideToLocco.reset()
            }
        }
        
        SMLocationManager.shared.handleLocationDidChanged = {
            if !self.isSetLocation {
                self.isSetLocation = true
                let camera = GMSCameraPosition.camera(withTarget: SMLocationManager.shared.currentLocation, zoom: self.googleMap.camera.zoom)
                self.googleMap.animate(to: camera)
            }
        }
    }
    
    //MARK: - MAP Helper
    func initiazeMap(){
        let options = GMSMapViewOptions()
        options.camera = GMSCameraPosition.camera(withLatitude: SMLocationManager.shared.currentLocation.latitude,
                                                  longitude: SMLocationManager.shared.currentLocation.longitude,
                                                  zoom: 12)
        options.frame = self.view.bounds
        
        googleMap = GMSMapView(options: options)
        googleMap.isMyLocationEnabled = true
        googleMap.settings.myLocationButton = false
        
        //Set style of map from json
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "GoogleMapStyle", withExtension: "json") {
                googleMap.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find GoogleMapStyle.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        
        self.mapBaseView.addSubview(googleMap)
    }
    
    func plotPOIOnMap() {
        googleMap.clear()
        for route in vmRoutes.arrPOI {
            for poi in route.triggerPoints {
                if let latitude = poi.coordinate.lat, let longitude = poi.coordinate.lng {
                    
                    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    //let marker = GMSAdvancedMarker(position: coordinate)
                    let marker = GMSMarker(position: coordinate)
                    marker.title = nil //route.name
                    marker.snippet = nil //route.formatedDescription
                    marker.icon = UIImage(named: "Marker")
                    marker.map = googleMap
                }
            }
        }
    }
    
}

extension UIViewController {
    func showCustomPopup(configuration:SMPopupConfigurations, completion: @escaping ((_ ide: String) -> ())) {
        let popup = SMPopupVC.load(withConfiguration: configuration)
        popup.modalPresentationStyle = .overCurrentContext
        self.present(popup, animated: false)
        popup.popupCloseWithHandler = completion
    }
    func showAudioPopup(configuration:RequestAudioPopupConfigurations, completion: @escaping ((_ ide: String) -> ())) {
        let popup = RequestAudioPopVC.load(withConfiguration: configuration)
        popup.modalPresentationStyle = .overCurrentContext
        self.present(popup, animated: false)
        popup.popupCloseWithHandler = completion
    }
    func showLanguagePopup(completion: @escaping ((_ ide: String) -> ())) {
        let popup = LanguageSelectionVC.loads()
        popup.modalPresentationStyle = .overCurrentContext
        self.present(popup, animated: false)
        popup.popupCloseWithHandler = completion
    }
    func showInfoPopup(configuration:InfoPopupVC.SMInfoConfigurations, completion: @escaping ((_ ide: String, _ popup:InfoPopupVC) -> ())) {
        let popup = InfoPopupVC.load(withConfiguration: configuration)
        popup.modalPresentationStyle = .overCurrentContext
        self.present(popup, animated: false)
        popup.popupCloseWithHandler = { id in
            completion(id, popup)
        }
    }
}
