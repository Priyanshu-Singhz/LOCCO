//
//  ProfileRadioButtonTblViewCell.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 16/02/24.
//

import UIKit

class ProfileRadioButtonTblViewCell: UITableViewCell {
    //MARK: - Outlet's
    @IBOutlet var emailNotEditLbl: UILabel!
    @IBOutlet weak var radioStackview: UIStackView!
    @IBOutlet weak var btnCheckmark: UIButton!
    @IBOutlet weak var keepMeLoopLbl: UILabel!
    @IBOutlet weak var btnSaveChanges: UIButton!
    var isChecked:Bool = true
    
    //MARK: - Properties
    var buttonSaveChangesCallback: (() -> Void)?
    var buttonUpdateCallback: (() -> Void)?
    var buttonCheckChangeCallback: ((Bool) -> Void)?
    //MARK: - AwakeFromNib
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.checkMarkClicked(_:)))
        radioStackview.addGestureRecognizer(tapGesture)
        updateButton()
        setupUI()
    }
    func setupUI(){
        emailNotEditLbl.text = "profile_page_warning".translated
        keepMeLoopLbl.text = "e-mail_registration_opti-in".translated
        btnSaveChanges.setTitle("profile_page_button".translated, for: .normal)
    }
    //MARK: - Button Action's
    @objc func stackViewTapped() {
        updateButton()
    }
    @IBAction func btnSaveChanges(_ sender: SMButton) {
        buttonSaveChangesCallback?()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBAction func checkMarkClicked(_ sender: UIButton) {
        isChecked = !isChecked
        updateButton()
        self.buttonCheckChangeCallback?(isChecked)
    }
    private func updateButton(){
        btnCheckmark.isSelected = self.isChecked
    }
    
    func setUpdateStatus(_ result:Bool) {
        self.isChecked = result
        updateButton()
    }
}
