//
//  HomeScreenListVC.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 15/02/24.
//

import UIKit

class HomeScreenListVC: UIViewController {
    //MARK: - Outltet's
    @IBOutlet weak var homeScreenListTbl: UITableView!
    //MARK: - Properties
    private var arrayModel:[SectionModel] = []
    fileprivate var vmHomeScreenList = ViewModelHomeScreenList()
    //MARK: - View Life Cycle's
    override func viewDidLoad() {
        super.viewDidLoad()
        managedSections()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("SM_MENU_CHANGE"), object: nil, queue: .main) { notification in
            if notification.object as? Bool == false {
                self.homeScreenListTbl.reloadSections([1], with: .none)
            }
        }
    }
    
    func managedSections(){
        homeScreenListTbl.register(UINib(nibName: "HeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "HeaderTableViewCell")
        homeScreenListTbl.register(UINib(nibName: "SectionTableCell", bundle: nil), forCellReuseIdentifier: "SectionTableCell")
        homeScreenListTbl.sectionHeaderTopPadding = 0
        homeScreenListTbl.showsHorizontalScrollIndicator = false
        homeScreenListTbl.showsVerticalScrollIndicator = false
        homeScreenListTbl.sectionHeaderHeight = 0
        homeScreenListTbl.tableHeaderView = nil
        arrayModel = vmHomeScreenList.arraySectionData
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
//MARK: -  Table View Delegate's
extension HomeScreenListVC:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayModel.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayModel[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let viewFooter = UIView(frame: .zero)
        viewFooter.backgroundColor = .clear
        return viewFooter
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowInfo = arrayModel[indexPath.section].rows[indexPath.row]
        let cellIdentifier = rowInfo.type ?? ""
        switch cellIdentifier {
        case "Header":
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderTableViewCell", for: indexPath) as! HeaderTableViewCell
            return cell
        case "Section":
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionTableCell", for: indexPath) as! SectionTableCell
            cell.selectionStyle = .none
            cell.setUpCell(rowInfo)
            
            cell.setRoundedCorner(rowCount: arrayModel[indexPath.section].rows.count - 1,
                                  currentIndex: indexPath.row)
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            cell.contentView.transform = CGAffineTransform(scaleX: 1.0, y: 0.7)
            UIView.animate(withDuration: GENERAL_ANIMATION_TIMING,
                           delay: 0,
                           usingSpringWithDamping: CGFloat(0.20),
                           initialSpringVelocity: CGFloat(6.0),
                           options: UIView.AnimationOptions.allowUserInteraction,
                           animations: {
                cell.contentView.transform = .identity
            })
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowInfo = arrayModel[indexPath.section].rows[indexPath.row]
        if rowInfo.Identifier == "myProfile" {
            if let profile = AppStoryboard.home.viewController(MyProfileVC.self) {
                self.navigationController?.pushViewController(profile, animated: true)
            }
        } else if rowInfo.Identifier == "routes" {
            if let route = AppStoryboard.home.viewController(RouteVC.self) {
                self.navigationController?.pushViewController(route, animated: true)
            }
        } else  if rowInfo.Identifier == "reminders" {
            if let reminder = AppStoryboard.main.viewController(ReminderVC.self) {
                self.navigationController?.pushViewController(reminder, animated: true)
            }
        } else  if rowInfo.Identifier == "discoveries" {
            if let discovery = AppStoryboard.home.viewController(DiscoveriesVC.self) {
                self.navigationController?.pushViewController(discovery, animated: true)
            }
        } else if rowInfo.type == "Header" {
            if let gamefication = AppStoryboard.home.viewController(GameProfileVC.self) {
                self.navigationController?.pushViewController(gamefication, animated: true)
            }
        }
        else  if rowInfo.Identifier == "faq" {
            if let faq = AppStoryboard.home.viewController(FaqVC.self) {
                self.navigationController?.pushViewController(faq, animated: true)
            }
        }
        else  if rowInfo.Identifier == "licence" {
            if let licence = AppStoryboard.home.viewController(LegalVc.self) {
                self.navigationController?.pushViewController(licence, animated: true)
            }
        }
    }
}
