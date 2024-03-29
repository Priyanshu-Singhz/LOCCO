//
//  AudioCardTableViewCell.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 21/02/24.
//

import UIKit

class AudioCardTableViewCell: UITableViewCell {
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var trailingConstant: NSLayoutConstraint!
    @IBOutlet var btnRoute: UIButton!
    @IBOutlet var leadingConstant: NSLayoutConstraint!
    @IBOutlet var selectRouteStack: UIStackView!
    @IBOutlet var baseViewStackView: UIStackView!
    @IBOutlet var hexagonImage: UIImageView!
    @IBOutlet var subTitleLbl: UILabel!
    @IBOutlet var routeLbl: UILabel!
    var isScreen:String?{
        didSet{
            if isScreen == "DrivingModeVC"{
                selectRouteStack.spacing = 8
                baseViewStackView.spacing = 24
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        routeLbl.text = "A3"
    }
    func configureCell(_ model:Rowmodel){
        imgView?.image = model.icon
        titleLbl.text = model.title.translated
        subTitleLbl.text = model.subtitle?.translated
    }
    func configureDrivingModeCell(_ model:Rowmodel){
        isScreen = "DrivingModeVC"
        trailingConstant.constant = 0
        leadingConstant.constant = 0
        imgView?.image = model.icon
        routeLbl.text = "A 123".translated
        routeLbl.font = AppFont.medium(size: 11)
        hexagonImage.image = UIImage(named: "hexagon")
        titleLbl.text = model.title.translated
        titleLbl.font = AppFont.bold(size: 15)
        subTitleLbl.text = model.subtitle?.translated
        subTitleLbl.font = AppFont.medium(size: 11)
        btnRoute.titleLabel?.font = AppFont.bold(size: 15)
    }
    @IBAction func routeBtnClicked(_ sender: UIButton) {
        print("Route button Tapped")
    }
    
}
