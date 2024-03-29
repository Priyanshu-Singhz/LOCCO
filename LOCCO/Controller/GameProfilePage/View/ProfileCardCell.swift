//
//  ProfileCardCell.swift
//  PinrestView
//
//  Created by Zignuts Technolab on 27/02/24.
//

import UIKit

class ProfileCardCell: UICollectionViewCell {

    @IBOutlet weak var imgvIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewCount: UIView!
    @IBOutlet weak var viewDescription: UIView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var lblScoreTotal: UILabel!
    @IBOutlet weak var lblPoint: UILabel!
    @IBOutlet weak var imgvCompleted: UIImageView!
    @IBOutlet weak var viewCompleted: UIView!
    @IBOutlet weak var viewCardBase: UIView!
    @IBOutlet var viewPoints: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func setupCell(_ item:MyMissionModel) {
        viewCompleted.isHidden = !item.isCompleted
        viewCount.isHidden = item.isExpanded
        viewDescription.isHidden = !item.isExpanded
        viewCardBase.backgroundColor = item.isCompleted ? UIColor.appWhite.withAlphaComponent(0.5) : UIColor.appBorder
        viewPoints.backgroundColor = item.isCompleted ? UIColor.appMint1.withAlphaComponent(0.6) : UIColor.appMint
        lblTitle.text = item.title
        lblDescription.text = item.description
        lblScore.text = String(item.score)
        lblScoreTotal.text = String(item.scoreTotal)
        lblPoint.text = "+\(item.points)"
        imgvIcon.image = item.image
    }

}
