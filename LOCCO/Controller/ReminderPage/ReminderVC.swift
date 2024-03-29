//
//  ReminderVC.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 21/02/24.
//

import UIKit

class ReminderVC: UIViewController {
    //MARK: - Outlet's
    @IBOutlet var emptyView: UIView!
    @IBOutlet var emptyViewLbl: UILabel!
    @IBOutlet var headerTextlbl: UILabel!
    @IBOutlet var noReminderLbl: UILabel!
    @IBOutlet var createReminderLbl: UILabel!
    @IBOutlet var headerReminderLbl: UILabel!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var remainderTblView: UITableView!
    @IBOutlet var headerView: UIView!
    //use fade animation instead of defult while go back
    var isFadeAnimation = false
    
    //MARK: - Properties
    fileprivate var vmReminder = ViewModelReminder()
    
    //MARK: - View Life Cycle's
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        remainderTblView.register(UINib(nibName: "ReminderTableViewCell", bundle: nil), forCellReuseIdentifier: "ReminderTableViewCell")
        remainderTblView.reloadData()
    }
    func setUpUI(){
        headerView.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 32)
        headerTextlbl.text = "home_reminder".translated.uppercased()
        noReminderLbl.text = "reminder_page_empty_default-text".translated
        createReminderLbl.text = "reminder_page_empty_button".translated
        headerReminderLbl.text = "homescreen_bentobox_view_reminder_set-title-reminder".translated
        btnBack.setTitle("back-button".translated, for: .normal)
        underLineText()
    }
    func underLineText() {
        let mainText = "reminder_page_empty_textbox".translated
        let underlineText = "settings"
        let attributedString = NSMutableAttributedString(string: mainText)
        if let range = mainText.range(of: underlineText) {
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(range, in: mainText))
            emptyViewLbl.attributedText = attributedString
        } else {
            emptyViewLbl.text = mainText
        }
    }

    //MARK: - Button Action's
    @IBAction func createNewReminderBtnClicked(_ sender: UIControl) {
        navigateToCreateReminder()
    }
    @IBAction func reminderBtnClicked(_ sender: UIControl) {
        navigateToCreateReminder()
    }
    
    @IBAction func backBtnClicked(_ sender: UIButton) {
        if isFadeAnimation {
            self.navigationController?.fadeAnimation()
        }
        self.navigationController?.popViewController(animated: !isFadeAnimation)
    }
    
    func navigateToCreateReminder() {
        if let createReminder = AppStoryboard.main.viewController(CreateReminderVC.self) {
            self.navigationController?.pushViewController(createReminder, animated: true)
        }
    }
}
//MARK: - Table View Delegate's
extension ReminderVC:UITableViewDelegate,UITableViewDataSource{
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows =  vmReminder.arraySectionData[section].rows
        emptyView.isHidden = rows.isEmpty ? false : true
        remainderTblView.isHidden = rows.isEmpty ? true : false
        return rows.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return vmReminder.arraySectionData.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        0
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowInfo = vmReminder.arraySectionData[indexPath.section].rows[indexPath.row]
        let cellIdentifier = rowInfo.type
        switch cellIdentifier {
        case "ReminderCell":
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderTableViewCell", for: indexPath) as! ReminderTableViewCell
            cell.configure(rowInfo)
            return cell
        default:
            return UITableViewCell()
        }
    }
}
