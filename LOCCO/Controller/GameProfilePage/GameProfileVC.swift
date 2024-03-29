//
//  GameProfileVC.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 22/02/24.
//

import UIKit

class GameProfileVC: UIViewController {
    
    @IBOutlet weak var collectionMain: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollMain: UIScrollView!
    @IBOutlet weak var navHeader: SMNavigationBar!
    private var vmGameProfile = ViewModelGameProfile()
    @IBOutlet weak var lblMissionTitle: UILabel!
    @IBOutlet var discoveriesCollectLbl: UILabel!
    @IBOutlet var dicoveryPointsLbl: UILabel!
    @IBOutlet var completeMissionLbl: UILabel!
    @IBOutlet var toLevelUpLbl: UILabel!
    @IBOutlet var nextLevelLbl: UILabel!
    @IBOutlet var explorerLbl: UILabel!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    //MARK: - Helper
    
    func setupUI() {
        //Header Corner radius
        navHeader.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 32)
        //My Profile text
        navHeader.navigationTitle = "JoÁquim".uppercased().translated
        //Handle back Action
        navHeader.backButtonClicked = { sender in
            self.navigationController?.popViewController(animated: true)
        }
        
        lblMissionTitle.text = "game_profile_title".translated.uppercased()
        discoveriesCollectLbl.text = "game_profile_information-box-1".translated
        //dicoveryPointsLbl.text = "game_profile_information-box-2".translated + " " + "game_profile_information-box-3".translated
        configureBulbText()
        explorerLbl.text = "Explorer".translated
        collectionMain.register(UINib(nibName: "ProfileCardCell", bundle: nil), forCellWithReuseIdentifier: "ProfileCardCell")
        (collectionMain.collectionViewLayout as? PinterestLayout)?.delegate = self
        reloadCollection()
    }
    
    func configureBulbText() {
        dicoveryPointsLbl.text = nil
        let image2Set = UIImage(named: "Lightbulb")!
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image2Set
        imageAttachment.bounds = CGRect(origin: .zero, size: CGSize(width: 15, height: 15))
        
        let fullText = "game_profile_information-box-2".translated + " " + "game_profile_information-box-3".translated
        let attString = NSMutableAttributedString(string:fullText)
        attString.insert(NSAttributedString(attachment: imageAttachment), at: 0)
        
        let range = (fullText as NSString).range(of: fullText)
        attString.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.appDarkBlue], range: range)
        
        dicoveryPointsLbl.attributedText = attString
    }
    
    func reloadCollection() {
        collectionMain.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.collectionViewHeight.constant = self.collectionMain.collectionViewLayout.collectionViewContentSize.height
            self.view.layoutIfNeeded()
        })
        
    }
}
//MARK: - UICollectionView Delegate's
extension GameProfileVC:UICollectionViewDelegate, UICollectionViewDataSource, PinterestLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath, cellWidth: CGFloat) -> CGFloat {
        let item = vmGameProfile.arrayMyMissionData[indexPath.row]
        var heightToSet:CGFloat = 32.0 + 30 + 57 + 32
        if item.isExpanded {
            heightToSet += item.description.heightWithConstrainedWidth(width: cellWidth, font: UIFont.systemFont(ofSize: 12, weight: .medium))
        } else {
            heightToSet += 28
        }
        return heightToSet
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vmGameProfile.arrayMyMissionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = vmGameProfile.arrayMyMissionData[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCardCell", for: indexPath) as! ProfileCardCell
        cell.setupCell(item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.vmGameProfile.arrayMyMissionData[indexPath.row].isExpanded = !self.vmGameProfile.arrayMyMissionData[indexPath.row].isExpanded
        self.reloadCollection()
    }
}
