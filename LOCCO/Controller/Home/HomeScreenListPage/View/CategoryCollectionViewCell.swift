//
//  CategoryCollectionViewCell.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 15/02/24.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var categoryImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func setUpUI(_ model:CategoryModel){
        categoryLbl.text = model.Count
        categoryImg.image = model.image
    }

}
