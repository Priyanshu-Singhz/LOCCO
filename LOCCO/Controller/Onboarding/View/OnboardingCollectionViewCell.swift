//
//  OnboardingCollectionViewCell.swift
//  Locco-OnBoarding-Screen
//
//  Created by Zignuts Technolab on 12/02/24.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var info1Lbl: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var info2Lbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    /// Setup UI according provided data
    func setupCell(_ model: ModelOnboardInfo) {
        img.image = UIImage(named:model.icon)
        info1Lbl.text = model.title.translated
        info2Lbl.text = model.description.translated
    }
}
