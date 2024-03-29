//
//  DiscoveriesVC.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 21/02/24.
//

import UIKit

class DiscoveriesVC: UIViewController {
    @IBOutlet weak var headerView: SMNavigationBar!
    @IBOutlet weak var discoveriesTblView: UITableView!
    //MARK: - Properties
    private var arrayModel:[SectionModel] = []
    fileprivate var vmDiscoveries = ViewModelDiscoveries()
    //use fade animation instead of defult while go back
    var isFadeAnimation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        discoveriesTblView.register(UINib(nibName: "infoTableViewCell", bundle: nil), forCellReuseIdentifier: "infoTableViewCell")
        discoveriesTblView.register(UINib(nibName: "AudioCardTableViewCell", bundle: nil), forCellReuseIdentifier: "AudioCardTableViewCell")
        arrayModel = vmDiscoveries.arraySectionData
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        MiniPlayerView.sharedInstance().closePopup()
    }
    
    func setUpUI(){
        headerView.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 32)
        headerView.navigationTitle = "home_discoveries".translated.uppercased()
        headerView.titleColor = .appDarkBlue
        headerView.backButtonClicked = { sender in
            if self.isFadeAnimation { self.navigationController?.fadeAnimation() }
            self.navigationController?.popViewController(animated: !self.isFadeAnimation)
        }
    }

}
extension DiscoveriesVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayModel[section].rows.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayModel.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowInfo = arrayModel[indexPath.section].rows[indexPath.row]
        let cellIdentifier = rowInfo.type
        switch cellIdentifier {
        case "HederInfo":
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoTableViewCell", for: indexPath) as! infoTableViewCell
            return cell
        case "Discoveries":
            let cell = tableView.dequeueReusableCell(withIdentifier: "AudioCardTableViewCell", for: indexPath) as! AudioCardTableViewCell
            cell.configureCell(rowInfo)
            return cell
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 || section == 2{
            return 12
        }else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 || section == 2 {
            let headerView = UIView()
            headerView.backgroundColor = UIColor.clear // Set the background color of the header
            
            let label = UILabel()
            label.font = AppFont.medium(size: 11)
            label.textColor = .appLightBlue
            label.translatesAutoresizingMaskIntoConstraints = false
            headerView.addSubview(label)
            
            // Add constraints to position the label with padding
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 30).isActive = true
            label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -30).isActive = true
            label.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
            label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
            
            // Set the title for the header based on the section index
            if section == 1 {
                label.text = "Wednesday, 01.01.2024"
            } else if section == 2 {
                label.text = "Tuesday, 01.01.2024"
            }
            
            return headerView
        }
       
        return nil // Return nil for sections without headers
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowInfo = arrayModel[indexPath.section].rows[indexPath.row]
        let cellIdentifier = rowInfo.type
        if cellIdentifier == "Discoveries" {
            if MiniPlayerView.shared == nil {
                MiniPlayerView.showMiniPlayerViewWithHandlers(mainView: self.view) {
                    self.discoveriesTblView.contentInset.bottom =  0
                }
                discoveriesTblView.contentInset.bottom =  MiniPlayerView.sharedInstance().bounds.height
                MiniPlayerView.shared?.handlerOpenFullPlayer = {
                    if let audioPlayer = AppStoryboard.driving.viewController(AudioPageVC.self) {
                        self.navigationController?.fadeAnimation()
                        self.navigationController?.pushViewController(audioPlayer, animated: false)
                    }
                }
            }
        }
    }
}
