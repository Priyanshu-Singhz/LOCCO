//
//  infoTableViewCell.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 21/02/24.
//

import UIKit

class infoTableViewCell: UITableViewCell {
    @IBOutlet weak var valueOneLbl: UILabel!
    @IBOutlet weak var valueTwoLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
