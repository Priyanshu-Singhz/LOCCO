//
//  SectionTableViewCell.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 15/02/24.
//

import UIKit

class SectionTableViewCell: UITableViewCell {
    //MARK: - Outlet's
    @IBOutlet var profileTtleText: UILabel!
    @IBOutlet var rightArrowImg: UIImageView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet var profileManageLbl: UILabel!
    @IBOutlet var righArrowImg: UIImageView!
    
    @IBOutlet var viewLeading: NSLayoutConstraint!
    @IBOutlet var viewTrailling: NSLayoutConstraint!
    
    //MARK: - Properties
    var separatorView: CustomSeparatorView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSeparatorView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    // Table View Cell Style
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSeparatorView()
    }
    
    // Set Up the UI
    func setUpUI(_ model:Rowmodel){
        categoryLbl.text = model.title
        imgView.image = model.icon
        // Setting Corner Radius
        if model.title == "My profile"{
            categoryView.roundCorners(corners: .allCorners, radius: 16)
        }
        if model.title == "Discoveries" || model.title == "How does LOCCO work?"{
            categoryView.roundCorners(corners: [.topLeft,.topRight], radius: 16)
        }
        if model.title == "Reminders" || model.title == "Licenses & Legal"{
            categoryView.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 16)
        }
        if model.title == "Routes" || model.title == "FAQs & Support" {
            categoryView.roundCorners(corners: .allCorners, radius: 0)
        }
        // Setting Up the Divider's
        if model.title == "Reminders" || model.title == "My profile" || model.title == "Licenses & Legal"{
            separatorView.isHidden = true
        }else{
            separatorView.isHidden = false
        }
    }
    // For Legal Screen VC
    func setupLegalVC(_ model:Rowmodel){
        categoryLbl.text = model.title
        imgView.image = model.icon
        // Right Arrow
        if model.type == "Sections"{
            rightArrowImg.isHidden = false
        }
        // Corner Radius
        if model.title == "Licenses"{
            categoryView.roundCorners(corners: [.topLeft,.topRight], radius: 16)
        }
        if model.title == "Terms & Conditions"{
            categoryView.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 16)
        }
        // Separator View
        if model.title == "Terms & Conditions"{
            separatorView.isHidden = true
        }else{
            separatorView.isHidden = false
        }
        //Custom Font
        if model.type == "Sections"{
            categoryLbl.font = UIFont(name: "Avenir Medium", size: 16)
        }
    }
    
    func myProfileSetup(_ model:Rowmodel){
        
        viewLeading.constant = 5
        viewTrailling.constant = 5
        categoryLbl.text = model.title
        imgView.image = model.icon
        //FOR MY PROFILE PAGE VC
        if model.title == "Manage account" {
            imgView.isHidden = true
            categoryLbl.isHidden = true
            profileManageLbl.isHidden = false
            righArrowImg.isHidden = true
            profileManageLbl.text = "Manage account"
            categoryView.roundCorners(corners: [.topLeft,.topRight], radius: 16)
        }
        if model.title == "Change password" || model.title == "Delete account"{
            categoryLbl.font = UIFont(name: "Avenir Medium", size: 16)
            imgView.isHidden = false
            categoryLbl.isHidden = false
            profileManageLbl.isHidden = true
            righArrowImg.isHidden = false
            categoryView.roundCorners(corners: [.topLeft,.topRight], radius: 0)
        }
        if model.title == "Logout" {
            imgView.isHidden = false
            categoryLbl.isHidden = false
            profileManageLbl.isHidden = true
            righArrowImg.isHidden = true
            categoryView.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 16)
            categoryLbl.font = UIFont(name: "Avenir Medium", size: 16)
        }
    }
    
    //Set Up the SeparatorView
    private func setupSeparatorView() {
        separatorView = CustomSeparatorView(frame: .zero)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(separatorView)
        
        // Add constraints for separator view
        separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
}

import UIKit

class CustomSeparatorView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = UIColor.appBGBlue // Customize color as needed
    }
}
