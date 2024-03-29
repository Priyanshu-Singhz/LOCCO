//
//  RequestAudioCollectionViewCell.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 01/03/24.
//

import UIKit

class RequestAudioCollectionViewCell: UICollectionViewCell {
    @IBOutlet var contentBg: UIView!
    @IBOutlet var categoryImg: UIImageView!
    @IBOutlet var categoryLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setUpUI(_ model: CategoryModel) {
        categoryLbl.text = model.text?.translated
        categoryImg.image = model.image
    }
}
