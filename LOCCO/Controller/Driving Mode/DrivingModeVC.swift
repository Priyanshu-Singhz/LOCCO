//
//  DrivingModeVC.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 29/02/24.
//

import UIKit

class DrivingModeVC: UIViewController {
    //MARK: - Outlet's
    @IBOutlet weak var btnExit: UIButton!
    @IBOutlet weak var lblNavPoint: UILabel!
    @IBOutlet weak var stackNextDiscovery: UIStackView!
    @IBOutlet weak var lblNextDiscovery: UILabel!
    @IBOutlet weak var lblPlaceTitle: UILabel!
    @IBOutlet weak var progressBar: ALProgressRing!
    @IBOutlet weak var lblNextTitle: UILabel!
    @IBOutlet weak var lblNextDetail: UILabel!
    @IBOutlet weak var viewNextKMBase: UIView!
    @IBOutlet weak var imgvAudio: UIImageView!
    @IBOutlet weak var viewKm: UIControl!
    @IBOutlet var btnRequestAudio: UIButton!
    @IBOutlet weak var lblKM: UILabel!
    @IBOutlet var requestAudioStack: UIStackView!
    @IBOutlet var discoverySomethingLbl: UILabel!
    @IBOutlet var discoveriesStack: UIStackView!
    @IBOutlet var discoveriesTbl: UITableView!
    @IBOutlet var lastDiscoveriesLbl: UILabel!
    //MARK: - Properties
    let pulsator = Pulsator()
    private var arrayModel:[SectionModel] = []
    fileprivate var vmDrivingMode = ViewModelDrivingMode()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        discoveriesTbl.register(UINib(nibName: "AudioCardTableViewCell", bundle: nil), forCellReuseIdentifier: "AudioCardTableViewCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showOnboarding()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layer.layoutIfNeeded()
        pulsator.position = viewKm.layer.position
    }
    //MARK: - Helper
    func initialSetup() {
        arrayModel = vmDrivingMode.arraySectionData
        btnExit.setTitle("driving_mode-exit".translated, for: .normal)
        lblNavPoint.text = String(format: "%.3f", 18.500)
        lblNextDiscovery.text = "driving_mode-title".translated
        lblPlaceTitle.text = "A123"
        lblNextTitle.text = "Schwarzer Berg Restaurant".translated
        lblNextDetail.text = "Restaurant".translated
        discoverySomethingLbl.text = "driving_mode-request-audio-title".translated
        btnRequestAudio.setTitle("driving_mode-request-audio-button".translated, for: .normal)
        lastDiscoveriesLbl.text = "driving_mode-last-discoveries".translated
        progressBar.lineWidth = 18.0
        progressBar.startColor = UIColor.appDarkBlue
        progressBar.endColor = UIColor.appDarkBlue
        progressBar.grooveColor = UIColor.appDarkBlue.withAlphaComponent(0.2)
        progressBar.timingFunction = .default
        progressBar.setProgress(0.8, animated: true)
        // Apply the configuration to the button
        btnRequestAudio.configuration = createButtonConfiguration()
        viewNextKMBase.layer.insertSublayer(pulsator, below: viewKm.layer)
        pulsator.numPulse = 5
        pulsator.animationDuration = 3.0
        pulsator.radius = 80
        pulsator.backgroundColor = UIColor.appSkyBlue.cgColor
        pulsator.start()
    }
    ///Opens Driving onboarding screen if not presented once
    func showOnboarding() {
        if !UserSession.shared.isShownDrivingOnboarding {
            showInstruction {
                if let onboardDriving = AppStoryboard.drivingOnboard.viewController(DrivingOnboardVC.self) {
                    onboardDriving.modalPresentationStyle = .overCurrentContext
                    onboardDriving.modalTransitionStyle = .crossDissolve
                    self.present(onboardDriving, animated: true)
                    onboardDriving.finishOnboardingHandler = {
                        self.showLocationPermissionDenied()
                    }
                }
            }
        } else {
            //Show location permission error
            showLocationPermissionDenied()
        }
    }
    
    func showInstruction(completion: @escaping (() -> ())) {
        let items:[String] = [
            "1. " + "drive_mode_onboarding_9_safety-step-1".translated,
            "2. " + "drive_mode_onboarding_9_safety-step-2".translated,
            "2. " + "drive_mode_onboarding_9_safety-step-3".translated,
            "2. " + "drive_mode_onboarding_9_safety-step-4".translated
        ]
        var configuration = InfoPopupVC.SMInfoConfigurations(items: items)
        configuration.title = "drive_mode_onboarding_9_safety-title".translated
        configuration.buttonConfig.title = "drive_mode_onboarding_9_safety-button".translated
        showInfoPopup(configuration: configuration) { (response, popup) in
            completion()
        }
    }
    
    func showLocationPermissionDenied() {
        if SMLocationManager.shared.isLocationDisabled {
            let items:[String] = [
                "drive_mode_onboarding_10_permission_denied-text".translated,
            ]
            var configuration = InfoPopupVC.SMInfoConfigurations(items: items)
            configuration.title = "drive_mode_onboarding_10_permission_denied-title".translated
            configuration.buttonConfig.title = "drive_mode_onboarding_10_permission_denied-button".translated
            configuration.isDisableDismissScreen = true
            configuration.isShowCloseButton = true
            showInfoPopup(configuration: configuration) { (response, popup) in
                if response == "close" {
                    //Close screen
                    popup.dismiss(animated: false)
                    self.exitClicked(true)
                } else {
                    //Open settings
                    if let appSettingsUrl = URL(string:UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(appSettingsUrl)
                    }
                }
            }
        }
    }
    
    
    //MARK: - Actions
    @IBAction func exitClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func kmClicked(_ sender: UIControl) {
        distancePopUp()
    }
    @IBAction func requestAudioBtnClicked(_ sender: UIButton) {
        var configuration = RequestAudioPopupConfigurations()
        configuration.title = "request_audio_categories_1-title"
        configuration.timeLbl = "10 Sec."
        configuration.buttonBreak = SMButtonConfigurations(idetifier: "BreakButton",title: "request_audio_categories_1-button")
        configuration.buttonCancel = SMButtonConfigurations(idetifier: "CancelButton",title: "cancel-button")
        self.showAudioPopup(configuration: configuration) { ide in
            appPrint("Popup close with action: ", ide)
        }
    }
    func distancePopUp(){
        var configuration = SMPopupConfigurations()
        configuration.title = "driving_mode-popover-title"
        let description = "driving_mode-popover-text"
        let phrase = "available on our \nselected routes."
        let customFont = AppFont.bold(size: 15)
        //Description Attributed Text
        let styledAttributedString = description.attributedStringWithFont(for: phrase, font: customFont)
        configuration.attributedDescription = styledAttributedString
        //Assign is Screen String
        configuration.isScreen = "DrivingModeVC"
        //Button Check routes
        configuration.button1 = SMButtonConfigurations(idetifier: "Check routes", title: "driving_mode-popover-route-button", background: UIColor.appWhite, borderColors: UIColor.appSkyBlue, textColor: UIColor.appSkyBlue)
        // Button Got it!
        configuration.button2 = SMButtonConfigurations(idetifier: "Got it!", title: "driving_mode-popover-accept-button", background: UIColor.appSkyBlue, borderColors: nil, textColor: .appWhite)
        self.showCustomPopup(configuration: configuration) { ide in
            appPrint("Popup close with action: ", ide)
        }
    }
}

//MARK: - TableViewDelegate
extension DrivingModeVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayModel[section].rows.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowInfo = arrayModel[indexPath.section].rows[indexPath.row]
        let cellIdentifier = rowInfo.type
        switch cellIdentifier {
        case "Discoveries":
            let cell = tableView.dequeueReusableCell(withIdentifier: "AudioCardTableViewCell", for: indexPath) as! AudioCardTableViewCell
            cell.configureDrivingModeCell(rowInfo)
            return cell
        default:
            return UITableViewCell()
        }
    }
}
