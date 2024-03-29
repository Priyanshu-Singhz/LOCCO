//
//  ReminderTableViewCell.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 21/02/24.
//

import UIKit

class ReminderTableViewCell: UITableViewCell{
    var popMenu:SwiftPopMenu!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var timeLbl: UILabel!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var contentViewBG: UIView!
    @IBOutlet var btnMenu: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func getCustomMenu() {
        let popData = [
            (icon: "Pen 2", title: "reminder_page-edit".translated),
            (icon: "Trash Bin Minimalistic 2", title: "reminder_page-delete".translated),
        ]
        let parameters: [SwiftPopMenuConfigure] = [
            .PopMenuTextColor(UIColor.appDarkBlue),
            .PopMenuBackgroudColor(UIColor.appWhite),
            .popMenuCornorRadius(16),
            .popMenuItemHeight(53),
            .PopMenuTextFont(AppFont.medium(size: 15)),
            .popMenuMargin(24),
            .popMenuSplitLineColor(.appPopMenuLine)
        ]
        // Convert the button's frame to the window's coordinate system
        guard let buttonFrame = btnMenu.superview?.convert(btnMenu.frame, to: nil) else {
            return
        }
        // Calculate the arrow point based on the button's frame
        let arrowPoint = CGPoint(x: buttonFrame.maxX + 12, y: buttonFrame.maxY-3.5)
        // Create SwiftPopMenu instance with the arrow point set to the button's position
        popMenu = SwiftPopMenu(menuWidth: 165, arrow: arrowPoint, datas: popData, configures: parameters)
        // Click handler
        popMenu.didSelectMenuBlock = { [weak self] index in
            print("block select \(index)")
            self?.popMenu = nil
        }
        // Show the pop-up menu
        popMenu.show()
    }
    @IBAction func menuBtnClicked(_ sender: UIButton) {
        getCustomMenu()
    }
    func configure(_ model:Rowmodel){
        titleLbl.text = model.title
        dateLbl.text = model.date
        timeLbl.text = model.time
    }
}
