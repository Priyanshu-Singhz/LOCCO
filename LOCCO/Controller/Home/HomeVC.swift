//
//  HomeVC.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 19/02/24.
//

import UIKit
let GENERAL_ANIMATION_TIMING = 0.5
class HomeVC: UIViewController {

    @IBOutlet weak var lblLevel: UILabel!
    @IBOutlet weak var imgvLevel: UIImageView!
    @IBOutlet weak var lblPlace: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblReminderPlaceholder: UILabel!
    @IBOutlet weak var imgvSpotlight: UIImageView!
    @IBOutlet weak var lblSPTitle: UILabel!
    @IBOutlet weak var lblSPValue: UILabel!
    @IBOutlet weak var btnSPPoint: SMButton!
    @IBOutlet weak var lblDesTitle: UILabel!
    @IBOutlet weak var lblDescValue: UILabel!
    @IBOutlet weak var collectionDes: UICollectionView!
    @IBOutlet weak var lblRoute: UILabel!
    @IBOutlet weak var viewSwitch: SMTileView!
    @IBOutlet weak var viewReminder: SMTileView!
    @IBOutlet weak var viewSpotlight: SMTileView!
    @IBOutlet weak var viewDiscovery: SMTileView!
    @IBOutlet weak var viewRoutes: SMTileView!
    @IBOutlet weak var switchMode: CustomSwitch!
    @IBOutlet weak var baseBentoBox: UIView!
    @IBOutlet weak var baseListView: UIView!
    @IBOutlet weak var btnMenu: SMButton!
    @IBOutlet weak var slideToLocco: SlideToActionButton!
    
    
    private var isShowBentoBox:Bool = true {
        didSet {
            switchHomeUI()
            DispatchQueue.main.asyncAfter(deadline: .now() + GENERAL_ANIMATION_TIMING/2, execute: {
                NotificationCenter.default.post(name: NSNotification.Name("SM_MENU_CHANGE"), object: self.isShowBentoBox)
            })
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        collectionDes.reloadData()
    }
    @IBAction func btnThemeToggle(_ sender: CustomSwitch) {
        //sender.thumbTintColor = sender.isOn ?  .appWhite :  .appLightBlue 
    }
    
    // MARK: - Actions
    @IBAction func menuClicked(_ sender: Any) {
        isShowBentoBox = !isShowBentoBox
        
        let image2Set = isShowBentoBox ? "ic_menu" : "ic_menu_open"
        UIView.transition(with: sender as! UIView, duration: 0.2, options: .transitionFlipFromRight, animations: {
            self.btnMenu.setImage(UIImage(named: image2Set), for: .normal)
        }, completion: nil)
    }
    
    
        
    // MARK: -  Helper
    func setupUI() {
        switchMode.onImage = UIImage(named: "ic_lightmode")
        switchMode.offImage = UIImage(named: "ic_darkmode")
        switchMode.thumbOffTintColor = UIColor.appLightBlue
        switchMode.thumbTintColor = UIColor.appMint
        lblPlace.text = "Joaquim".uppercased().translated
        lblReminderPlaceholder.text = "homescreen_bentobox_default_view_reminder-text".translated
        lblSPTitle.text = "homescreen_bentobox_view_spotlight-text".translated
        lblSPValue.text = "Spotlight".uppercased().translated
        lblDesTitle.text = "homescreen_bentobox_default_view_discoveries-text".translated
        lblDescValue.text = "home_discoveries".translated.uppercased()
        lblRoute.text = "home_routes".translated.uppercased()
        collectionDes.register(UINib(nibName: "CellDescovery", bundle: nil), forCellWithReuseIdentifier: "CellDescovery")
        //Add action to tiles
        viewRoutes.tileDidClicked = {
            if let route = AppStoryboard.home.viewController(RouteVC.self) {
                route.isFadeAnimation = true
                self.navigationController?.fadeAnimation()
                self.navigationController?.pushViewController(route, animated: false)
            }
        }
        
        viewReminder.tileDidClicked = {
            if let reminder = AppStoryboard.main.viewController(ReminderVC.self) {
                reminder.isFadeAnimation = true
                self.navigationController?.fadeAnimation()
                self.navigationController?.pushViewController(reminder, animated: false)
            }
        }
        
        viewDiscovery.tileDidClicked = {
            if let discovery = AppStoryboard.home.viewController(DiscoveriesVC.self) {
                discovery.isFadeAnimation = true
                self.navigationController?.fadeAnimation()
                self.navigationController?.pushViewController(discovery, animated: false)
            }
        }
        
        slideToLocco.handleDidFinish = {
            if let onboard = AppStoryboard.driving.viewController(DrivingModeVC.self) {
                self.navigationController?.pushViewController(onboard, animated: true)
                self.slideToLocco.reset()
            }
        }
    }
    
    func switchHomeUI() {
        if isShowBentoBox {
            UIView.transition(with: baseBentoBox, duration: GENERAL_ANIMATION_TIMING) {
                self.baseBentoBox.alpha = 1.0
                self.baseListView.alpha = 0.0
            }
        } else {
            UIView.transition(with: baseListView, duration: GENERAL_ANIMATION_TIMING) {
                self.baseBentoBox.alpha = 0.0
                self.baseListView.alpha = 1.0
            }
        }
        showHidBoxesAnimation()
    }
    
    
    func showHidBoxesAnimation() {
        let center2Move = viewSpotlight.center
        let velcoCity = isShowBentoBox ? 6.5 : 1.0
        let damping = isShowBentoBox ? 0.20 : 1.0
        UIView.animate(withDuration: GENERAL_ANIMATION_TIMING,
                       delay: 0,
                       usingSpringWithDamping: damping,
                       initialSpringVelocity: velcoCity,
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
            if self.isShowBentoBox {
                self.viewReminder.transform = .identity
                self.viewDiscovery.transform = .identity
                self.viewRoutes.transform = .identity
            } else {
                self.viewReminder.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                    .concatenating(CGAffineTransform(translationX: (center2Move.x - self.viewSwitch.center.x),
                                                     y: (center2Move.y - self.viewReminder.center.y)))
                self.viewDiscovery.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                    .concatenating(CGAffineTransform(translationX: (center2Move.x - self.viewDiscovery.center.x),
                                                     y: (self.viewDiscovery.center.y - center2Move.y)))
                self.viewRoutes.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                    .concatenating(CGAffineTransform(translationX: (center2Move.x - self.viewRoutes.center.x),
                                                     y: (self.viewRoutes.center.y - center2Move.y)))
            }
        })
        
    }
    
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width/2.5), height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellDescovery", for: indexPath) as! CellDescovery
        return cell
    }
    
    
}
