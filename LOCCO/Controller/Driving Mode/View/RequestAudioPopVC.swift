//
//  RequestAudioPopVC.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 01/03/24.
//

import UIKit
struct RequestAudioPopupConfigurations {
    ///Title you want to show
    var title:String?
    ///Description you want to show.
    var timeLbl:String?
    /// Button 1 configuration. Set nill if you want to hide this button
    var buttonBreak:SMButtonConfigurations?
    ///Button 2 configuration. Set nill if you want to hide this button
    var buttonCancel:SMButtonConfigurations?
}
class RequestAudioPopVC: UIViewController {
    //MARK: - Outlet's
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet weak var baseViewPopup: UIView!
    @IBOutlet var timeLbl: UILabel!
    @IBOutlet var breakBtnView: UIView!
    @IBOutlet var audioCollectioView: UICollectionView!
    @IBOutlet var successPopUpView: UIView!
    @IBOutlet var btnBreak: SMButton!
    @IBOutlet var btnCancel: SMButton!
    //Booster Pop Up
    @IBOutlet var boosterPopUpImg: UIImageView!
    @IBOutlet var boosterPopUpTitleLbl: UILabel!
    @IBOutlet var boosterPopUpDescLbl: UILabel!
    @IBOutlet var boosterPopUpScoreLbl: UILabel!
    
    //MARK: - Properties
    var configuration:RequestAudioPopupConfigurations!
    var popupCloseWithHandler:((String) -> ())? = nil
    fileprivate var vmDrivingMode = ViewModelDrivingMode()
    var arrCatgroyModel:[CategoryModel] = []
    /// Helps to create instance of SMPopupVC with configuration
    static func load(withConfiguration config:RequestAudioPopupConfigurations) -> RequestAudioPopVC {
        let popup = RequestAudioPopVC(nibName: "RequestAudioPopVC", bundle: nil)
        popup.configuration = config
        return popup
    }
    //MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        audioCollectioView.register(UINib(nibName: "RequestAudioCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RequestAudioCollectionViewCell")
        audioCollectioView.delegate = self
        audioCollectioView.dataSource = self
    }
    // MARK: - UI Setup
    private func setupUI() {
        arrCatgroyModel = vmDrivingMode.arrayCategoryData
        //Configure title
        titleLbl.text = configuration.title?.translated
        //Configure Time Label
        timeLbl.text = configuration.timeLbl?.translated
        //Button Break
        if let breakBtn = configuration.buttonBreak {
            btnBreak.buttonID = breakBtn.idetifier
            btnBreak.setTitle(breakBtn.title?.translated, for: .normal)
        }
        //Button Cancel
        if let cancelBtn = configuration.buttonCancel {
            btnCancel.buttonID = cancelBtn.idetifier
            btnCancel.setTitle(cancelBtn.title?.translated, for: .normal)
        }
        // Description Attributed Text
        boosterPopupDescriptionAttributedText()
        //Set up image Padding
    }
    func boosterPopupDescriptionAttributedText(){
        let description = "community_booster_popup-text".translated
        let phrase = "100 EPs!"
        //Booster PopUp Desciption Label
        boosterPopUpDescLbl.attributedText = description.attributedStringWithFont(for: phrase, font:  AppFont.bold(size: 15))
    }
    // MARK: - Actions
    @IBAction func breakButtonTapped(_ sender: UIButton) {
        vmDrivingMode.createCategoryData1()
        arrCatgroyModel = vmDrivingMode.arrayCategoryData
        titleLbl.text = "request_audio_categories_2-title".translated
        breakBtnView.isHidden = true
        audioCollectioView.reloadData()
    }
    
    @IBAction func popUpCloseClicked(_ sender: UIButton) {
        self.hideAnimation(completions: {
            self.dismiss(animated: false) {}
        },view: baseViewPopup)
    }
    @IBAction func cancelButtonTapped(_ sender: SMButton) {
        self.hideAnimation(completions: {
            self.dismiss(animated: false) {
                self.popupCloseWithHandler?(sender.buttonID)
            }
        },view: baseViewPopup)
        
    }
    // Handle tap events on the background overlay view
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: baseViewPopup)
        // Check if the tap is outside the baseViewPopup
        if !baseViewPopup.frame.contains(point) {
            self.hideAnimation(completions: {
                self.dismiss(animated: false) {}
            }, view: baseViewPopup)
        }
    }
    
    //MARK: - Methods
    // Showing the Animation
    private func showAnimation(for view: UIView) {
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.7),
                       initialSpringVelocity: CGFloat(0.1),
                       options: [.allowUserInteraction],
                       animations: {
            view.transform = .identity
        }) { finish in
            
        }
    }
    // Hide Animation
    private func hideAnimation(completions: @escaping (() -> ()),view:UIView) {
        UIView.animate(withDuration: 0.2) {
            view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        } completion: { finish in
            completions()
        }
    }
}
//MARK: - CollectionViewDelegate
extension RequestAudioPopVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCatgroyModel.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width
        let cellWidth = availableWidth / 2
        return CGSize(width: cellWidth, height: 119)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RequestAudioCollectionViewCell", for: indexPath) as! RequestAudioCollectionViewCell
        cell.setUpUI(arrCatgroyModel[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.hideAnimation(completions: {
            self.successPopUpView.isHidden = false
            self.showAnimation(for: self.successPopUpView)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.hideAnimation(completions: {
                    self.dismiss(animated: false) {}
                }, view: self.successPopUpView)
            }
        }, view: baseViewPopup)
    }
}
