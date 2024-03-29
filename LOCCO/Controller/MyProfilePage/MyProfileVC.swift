import UIKit

class MyProfileVC: UIViewController {
    // Outlets
    @IBOutlet weak var navigationHeader: SMNavigationBar!
    @IBOutlet weak var myProfileTbl: UITableView!
    // Properties
    var changesMade: Bool = false {
        didSet {
            self.changeButtonStateCallback?()
        }
    }
    var isPassChanged:Bool = false
    fileprivate var vmProfilePage = ViewModelProfilePage()
    var changeButtonStateCallback: (() -> ())?
    // View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        manageSections()
        setupUI()
    }
    // Actions
    
    // Helper Methods
    func manageSections() {
        myProfileTbl.register(UINib(nibName: "ProfileTextFieldTblViewCell", bundle: nil), forCellReuseIdentifier: "ProfileTextFieldTblViewCell")
        myProfileTbl.register(UINib(nibName: "ProfileRadioButtonTblViewCell", bundle: nil), forCellReuseIdentifier: "ProfileRadioButtonTblViewCell")
        myProfileTbl.register(UINib(nibName: "EditProfileTblViewCell", bundle: nil), forCellReuseIdentifier: "EditProfileTblViewCell")
        myProfileTbl.register(UINib(nibName: "SectionTableCell", bundle: nil), forCellReuseIdentifier: "SectionTableCell")
    }
    
    func setupUI() {
        navigationHeader.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 32)
        navigationHeader.navigationTitle = "home_profile".translated.uppercased()
        navigationHeader.backButtonClicked = { sender in
            self.navigationController?.popViewController(animated: true)
        }
    }
    func saveChangesButtonTapped() {
        if vmProfilePage.validateEmail() {}
        
        if let section = vmProfilePage.arraySectionData.firstIndex(where: {return $0.identifier == "Textfields"}) {
            myProfileTbl.reloadSections([section], with: .none)
        }
    }
}
// TableView Delegate
extension MyProfileVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vmProfilePage.arraySectionData[section].rows.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return vmProfilePage.arraySectionData.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowInfo = vmProfilePage.arraySectionData[indexPath.section].rows[indexPath.row]
        let cellIdentifier = rowInfo.type ?? ""
        switch cellIdentifier {
        case "Edit Profile":
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileTblViewCell", for: indexPath) as! EditProfileTblViewCell
            cell.editProfileLbl.text = rowInfo.title.translated
            return cell
        case "textfield":
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTextFieldTblViewCell", for: indexPath) as! ProfileTextFieldTblViewCell
            cell.configure(with: rowInfo, at: indexPath)
            cell.customTextField.text = self.vmProfilePage.dictValues[rowInfo.Identifier] as? String
           
            //Set error
            cell.customTextField.leadingAssistiveLabel.text = nil
            if rowInfo.Identifier == TextFieldIdetifier.name.rawValue {
                cell.customTextField.leadingAssistiveLabel.text  = vmProfilePage.nameError
            }
            
            cell.textfieldDidChanged = {(identifier, value) in
                self.vmProfilePage.resetErrors()
                if let strIde = identifier {
                    self.vmProfilePage.dictValues[strIde] = value
                    self.changesMade = true
                }
            }
            return cell
        case "radioButton":
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileRadioButtonTblViewCell", for: indexPath) as! ProfileRadioButtonTblViewCell
            cell.setUpdateStatus(self.vmProfilePage.dictValues["updates"] as? Bool ?? true)
            self.changeButtonStateCallback = {
                cell.btnSaveChanges.isEnabled = true
                cell.btnSaveChanges.alpha =  1
            }
            cell.buttonCheckChangeCallback = { isCheck in
                self.vmProfilePage.dictValues["updates"] = isCheck
            }
            cell.buttonSaveChangesCallback = {
                self.saveChangesButtonTapped()
                appPrint("Saved clicked: -> ", self.vmProfilePage.dictValues as NSDictionary)
            }
            return cell
        case "Manage account":
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionTableCell", for: indexPath) as! SectionTableCell
            //cell.myProfileSetup(rowInfo)
            cell.selectionStyle = .none
            cell.setUpCell(rowInfo)
            cell.setRoundedCorner(rowCount: vmProfilePage.arraySectionData[indexPath.section].rows.count - 1,
                                  currentIndex: indexPath.row)
            cell.lblTitle.font = rowInfo.Identifier == "Manage account" ? AppFont.bold(size: 18) : AppFont.medium(size: 16)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowInfo = vmProfilePage.arraySectionData[indexPath.section].rows[indexPath.row]
        if rowInfo.Identifier == "Delete account" {
            if let profile = AppStoryboard.home.viewController(DeleteAccountVC.self) {
                self.navigationController?.pushViewController(profile, animated: true)
            }
        }
        if rowInfo.Identifier == "Change password" {
            if let profile = AppStoryboard.home.viewController(ChangePasswordVC.self) {
                self.navigationController?.pushViewController(profile, animated: true)
            }
        }
        else if rowInfo.Identifier == "Language" {
           
            self.showLanguagePopup { ide in
                appPrint("Popup close with action: ", ide)
            }
            
        }
        if rowInfo.Identifier == "Logout" {
            SMHud.animate()
            UserSession.shared.logoutUser { isSucess, message in
                SMHud.dimiss()
            }
        }
    }
}
