//
//  FAQHeaderTableViewCell.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 28/02/24.
//

import UIKit

class FAQHeaderTableViewCell: UITableViewCell {

    @IBOutlet var headerLbl: UILabel!
    @IBOutlet var bottomConstants: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(_ model:Rowmodel){
       headerLbl.text = model.title.translated
       bottomConstants.constant = 32
    }
}
