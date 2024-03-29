//
//  FaqVc.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 28/02/24.
//

import UIKit

class LegalVc: UIViewController {
    @IBOutlet var navHeader: SMNavigationBar!
    @IBOutlet var legalTbl: UITableView!
    // Properties
    var arrSectionModel: [SectionModel] = []
    fileprivate var vmLegal = ViewModelLegal()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        legalTbl.register(UINib(nibName: "FAQHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "FAQHeaderTableViewCell")
        legalTbl.register(UINib(nibName: "SectionTableCell", bundle: nil), forCellReuseIdentifier: "SectionTableCell")
        legalTbl.register(UINib(nibName: "ContactInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "ContactInfoTableViewCell")
    }
    func setUpUI(){
        arrSectionModel = vmLegal.arraySectionData
        navHeader.navigationTitle = "legal-licenses_page-title".translated.uppercased()
        navHeader.backButtonClicked = { sender in
            self.navigationController?.popViewController(animated: true)
        }
        navHeader.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 32)
    }

}
// TableView Delegate
extension LegalVc: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSectionModel[section].rows.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrSectionModel.count
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowInfo = arrSectionModel[indexPath.section].rows[indexPath.row]
        let cellIdentifier = rowInfo.type ?? ""
        
        switch cellIdentifier {
        case "Licenses & Legal":
            let cell = tableView.dequeueReusableCell(withIdentifier: "FAQHeaderTableViewCell", for: indexPath) as! FAQHeaderTableViewCell
            cell.configure(rowInfo)
            return cell
        case "Sections":
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionTableCell", for: indexPath) as! SectionTableCell
            cell.selectionStyle = .none
            
            cell.setUpCell(rowInfo)
            
            cell.setRoundedCorner(rowCount: arrSectionModel[indexPath.section].rows.count - 1,
                                  currentIndex: indexPath.row)
            return cell
        case "ContactEmail":
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactInfoTableViewCell", for: indexPath) as! ContactInfoTableViewCell
            return cell
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowInfo = arrSectionModel[indexPath.section].rows[indexPath.row]
        
        if rowInfo.Identifier == "" {}
    }
}

