//
//  DrivingOnboardVC.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 11/03/24.
//

import UIKit
import JXPageControl

class DrivingOnboardVC: UIViewController {
    
    @IBOutlet weak var btnBack: SMButton!
    @IBOutlet weak var pageController: JXPageControlScale!
    @IBOutlet weak var btnClose: SMButton!
    @IBOutlet weak var collectionMain: UICollectionView!
    @IBOutlet weak var viewSpeechBubble: UIView!
    
    var vmOnboarding:VMDrivingOnboarding = VMDrivingOnboarding()
    var finishOnboardingHandler:(() -> ())? = nil
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        UserSession.shared.isShownDrivingOnboarding = true
        pageController.numberOfPages = vmOnboarding.arrTutorial.count
        initialSetup()
        collectionMain.reloadData()
    }
    
    // MARK: - Action
    @IBAction func backClicked(_ sender: Any) {
        self.swipeRight()
    }
    
    @IBAction func closeClicked(_ sender: Any) {
        self.dismiss(animated: true) {
            self.finishOnboardingHandler?()
        }
    }
    // MARK: - Helper
    
    func initialSetup() {
        //Register cells
        collectionMain.register(UINib(nibName: "OBCellProgress", bundle: nil), forCellWithReuseIdentifier: "OBCellProgress")
        collectionMain.register(UINib(nibName: "OBCellNextDiscovery", bundle: nil), forCellWithReuseIdentifier: "OBCellNextDiscovery")
        collectionMain.register(UINib(nibName: "OBCellAudioPlayer", bundle: nil), forCellWithReuseIdentifier: "OBCellAudioPlayer")
        collectionMain.register(UINib(nibName: "OBCellRequest", bundle: nil), forCellWithReuseIdentifier: "OBCellRequest")
        collectionMain.register(UINib(nibName: "OBCellStopOver", bundle: nil), forCellWithReuseIdentifier: "OBCellStopOver")
        //Set text
        btnBack.setTitle("  " + "back".translated, for: .normal)
        //Add swipe left & right gesture to collectionview
        collectionMain.addGestureRecognizer(createSwipeGestureRecognizer(for: .left))
        collectionMain.addGestureRecognizer(createSwipeGestureRecognizer(for: .right))
        reloadPage()
    }
    
    private func createSwipeGestureRecognizer(for direction: UISwipeGestureRecognizer.Direction) -> UISwipeGestureRecognizer {
        // Initialize Swipe Gesture Recognizer
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        
        // Configure Swipe Gesture Recognizer
        swipeGestureRecognizer.direction = direction
        
        return swipeGestureRecognizer
    }
    
    /// Executes when user swipes the collectionview
    @objc private func didSwipe(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .left:
            self.swipeLeft()
        case .right:
            self.swipeRight()
        default:
            break
        }
    }
    /// Go to next page if exist
    func swipeLeft() {
        if (vmOnboarding.currentPage + 1) < vmOnboarding.arrTutorial.count {
            vmOnboarding.currentPage += 1
            reloadPage()
        }
    }
    /// Go to previous page if exist
    func swipeRight() {
        if (vmOnboarding.currentPage - 1) >= 0 {
            vmOnboarding.currentPage -= 1
            reloadPage()
        }
    }
    
    func reloadPage()  {
        collectionMain.scrollToItem(at: IndexPath(item: vmOnboarding.currentPage, section: 0), at: .centeredHorizontally, animated: false)
        pageController.currentPage  = vmOnboarding.currentPage
        btnBack.alpha = (vmOnboarding.currentPage == 0 ? 0:1)
        UIView.transition(with: self.collectionMain, duration: 0.2, options: .transitionCrossDissolve) {
        }
    }
    
}

// MARK: - CollectionView Method

extension DrivingOnboardVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vmOnboarding.arrTutorial.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cframe = collectionView.frame
        return CGSize(width: cframe.width, height: cframe.height)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = vmOnboarding.arrTutorial[indexPath.row]
        
        if  item.id == "nextDiscovery" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OBCellNextDiscovery", for: indexPath) as! OBCellNextDiscovery
            cell.setupCell(item)
            cell.animateValue(ishow: false)
            return cell
        } else if  item.id == "audioPlayer" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OBCellAudioPlayer", for: indexPath) as! OBCellAudioPlayer
            cell.setupCell(item)
            cell.animateValue(ishow: false)
            return cell
        } else if  item.id == "requestAudio" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OBCellRequest", for: indexPath) as! OBCellRequest
            cell.setupCell(item)
            cell.animateValue(ishow: false)
            return cell
        } else if  item.id == "addStopOver" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OBCellStopOver", for: indexPath) as! OBCellStopOver
            cell.setupCell(item)
            cell.animateValue(ishow: false)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OBCellProgress", for: indexPath) as! OBCellProgress
            cell.setupCell(item)
            cell.animateValue(ishow: false)
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //Reset animation frame while cell displays end.
        if let cell1 = cell as? OBCellNextDiscovery {
            cell1.animateValue(ishow: false)
        }
        if let cell1 = cell as? OBCellProgress {
            cell1.animateValue(ishow: false)
        }
        if let cell1 = cell as? OBCellRequest {
            cell1.animateValue(ishow: false)
        }
        if let cell1 = cell as? OBCellStopOver {
            cell1.animateValue(ishow: false)
        }
        if let cell1 = cell as? OBCellAudioPlayer {
            cell1.animateValue(ishow: false)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //start animation of the view while cell are about to show
        if let cell1 = cell as? OBCellNextDiscovery {
            cell1.animateValue(ishow: true)
        }
        if let cell1 = cell as? OBCellProgress {
            cell1.animateValue(ishow: true)
        }
        if let cell1 = cell as? OBCellRequest {
            cell1.animateValue(ishow: true)
        }
        if let cell1 = cell as? OBCellStopOver {
            cell1.animateValue(ishow: true)
        }
        if let cell1 = cell as? OBCellAudioPlayer {
            cell1.animateValue(ishow: true)
        }
    }
    
}

