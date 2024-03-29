//
//  DeleteAccountVC.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 27/02/24.
//

import UIKit

class DeleteAccountVC: UIViewController {

    @IBOutlet var deleteAccountLbl: UILabel!
    @IBOutlet var agreeLbl: UILabel!
    @IBOutlet var orLbl: UILabel!
    @IBOutlet var popUpTitleLbl: UILabel!
    @IBOutlet var popUpDescLbl: UILabel!
    @IBOutlet var btnDeleteAccount: UIButton!
    @IBOutlet var btnLogout: UIButton!
    @IBOutlet var btnIamSure: UIButton!
    @IBOutlet var deletePopView: UIView!
    @IBOutlet var btnCancel: UIButton!
    @IBOutlet var headerView: SMNavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    func setupUI(){
        headerView.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 32)
        headerView.navigationTitle = "home_profile".translated.uppercased()
        headerView.backButtonClicked = { sender in
            self.navigationController?.popViewController(animated: true)
        }
        btnDeleteAccount.setTitle("profile_page_delete_account-button".translated, for: .normal)
        btnLogout.setTitle("profile_page_bottom-button".translated, for: .normal)
        deleteAccountLbl.text = "profile_page_delete_account-title".translated
        agreeLbl.text = "profile_page_delete_account-warning".translated
        orLbl.text = "profile_page_delete_account-or".translated
        popUpTitleLbl.text = "profile_page_delete_account-popover-title".translated
        popUpDescLbl.text = "profile_page_delete_account-popover-text".translated
        btnIamSure.setTitle("profile_page_delete_account-popover-button".translated, for: .normal)
        btnCancel.setTitle("cancel-button".translated, for: .normal)
        
    }
    @IBAction func deleteAccountBtnClicked(_ sender: UIButton) {
        deletePopView.isHidden = false
    }
    @IBAction func logoutBtnClicked(_ sender: UIButton) {
        UserSession.shared.clear()
    }
    
    @IBAction func yesDeleteBtnPressed(_ sender: UIButton) {
    }
    @IBAction func cancelBtnPressed(_ sender: UIButton) {
        deletePopView.isHidden = true
    }
}
