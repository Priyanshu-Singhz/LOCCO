//
//  LanguageSelectionVC.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 12/03/24.
//

import UIKit

class LanguageSelectionVC: UIViewController {
    @IBOutlet var closePopUpBtn: UIButton!
    @IBOutlet var myLanguageTbl: UITableView!
    //MARK: - Properties
    var selectedLanguage: String?
    var popupCloseWithHandler:((String) -> ())? = nil
    fileprivate var vmProfilePage = ViewModelProfilePage()
    var arrayModelData:[SectionModel] = []
    // Helps to create an instance of LanguageSelectionVC with configuration
    static func loads() -> LanguageSelectionVC {
        let popup = LanguageSelectionVC(nibName: "LanguageSelectionVC", bundle: nil)
        return popup
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        myLanguageTbl.register(UINib(nibName: "SectionTableCell", bundle: nil), forCellReuseIdentifier: "SectionTableCell")
        myLanguageTbl.dataSource = self
        myLanguageTbl.delegate = self
        arrayModelData = vmProfilePage.createLanguageData()
    }
    @IBAction func closePopUpClicked(_ sender: UIButton) {
        self.dismiss(animated: false)
    }
}


extension LanguageSelectionVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayModelData[section].rows.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayModelData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowInfo = arrayModelData[indexPath.section].rows[indexPath.row]
        let cellIdentifier = rowInfo.type ?? ""
        switch cellIdentifier {
        case "Language":
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionTableCell", for: indexPath) as! SectionTableCell
            cell.setUpCell(rowInfo,true)
            cell.setRoundedCorner(rowCount: arrayModelData[indexPath.section].rows.count - 1,
                                  currentIndex: indexPath.row)
            return cell
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowInfo = arrayModelData[indexPath.section].rows[indexPath.row]
        if rowInfo.Identifier == AppLaunguage.shared.currentLanguage {
            //Same language already selected.
            self.dismiss(animated: false)
        } else {
            //Change language and reload application
            AppLaunguage.shared.setLanguage(rowInfo.Identifier)
            UIApplication.appDelegate?.switchToHome()
        }
    }
}
