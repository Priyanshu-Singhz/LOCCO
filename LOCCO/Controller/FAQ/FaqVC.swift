import UIKit

class FaqVC: UIViewController {
    //MARK: - Outlet's
    @IBOutlet var navHeader: SMNavigationBar!
    @IBOutlet var faqTbl: UITableView!
    @IBOutlet var sendUsEmailLbl: UILabel!
    @IBOutlet var emailNameLbl: UILabel!
    @IBOutlet var furtherQuestionLbl: UILabel!
    //MARK: - Properties
    var arrSectionModel: [SectionModel] = []
    fileprivate var vmFaq = ViewModelFAQ()
    var expandedFAQIndices: Set<Int> = [] // Keep track of expanded FAQ indices
    //MARK: - View Life Cycle's
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        faqTbl.register(UINib(nibName: "FAQHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "FAQHeaderTableViewCell")
        faqTbl.register(UINib(nibName: "FAQTableViewCell", bundle: nil), forCellReuseIdentifier: "FAQTableViewCell")
        faqTbl.showsVerticalScrollIndicator = false
        faqTbl.showsHorizontalScrollIndicator = false
        faqTbl.contentInset.bottom = 110
    }
    func setUpUI() {
        arrSectionModel = vmFaq.arraySectionData
        navHeader.navigationTitle = "faq_support_page-title".translated.uppercased()
        navHeader.backButtonClicked = { sender in
            self.navigationController?.popViewController(animated: true)
        }
        navHeader.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 32)
        furtherQuestionLbl.text = "faq_support_page-contact-box-question".translated
        sendUsEmailLbl.text = "faq_support_page-contact-box-text".translated
        emailNameLbl.text = "faq_support_page-contact-box-mail".translated
    }
    @IBAction func helpBtnClicked(_ sender: UIControl) {
        let email = "hello@locco.app"
        if let url = URL(string: "mailto:\(email)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url) { success in
                if !success {
                    // Handle the case where opening the URL failed
                    print("Failed to open URL: \(url)")
                }
            }
        } else {
            // Handle the case where the URL is invalid or the device can't open it
            print("Invalid email URL or device can't open it: \(email)")
        }
    }
}

//MARK: - TableView Delegate
extension FaqVC: UITableViewDelegate, UITableViewDataSource {
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowInfo = arrSectionModel[indexPath.section].rows[indexPath.row]
        let cellIdentifier = rowInfo.type ?? ""
        
        switch cellIdentifier {
        case "FAQs & Support":
            let cell = tableView.dequeueReusableCell(withIdentifier: "FAQHeaderTableViewCell", for: indexPath) as! FAQHeaderTableViewCell
            cell.headerLbl.text = rowInfo.title.translated
            return cell
        case "FAQs":
            let cell = tableView.dequeueReusableCell(withIdentifier: "FAQTableViewCell", for: indexPath) as! FAQTableViewCell
            cell.configure(rowInfo)
            cell.isExpanded = expandedFAQIndices.contains(indexPath.row)
            return cell
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? FAQTableViewCell else {
            return
        }
        if expandedFAQIndices.contains(indexPath.row) {
            // Collapse the FAQ
            expandedFAQIndices.remove(indexPath.row)
        } else {
            // Expand the FAQ
            expandedFAQIndices.insert(indexPath.row)
        }
        // Reload the table view to reflect the changes
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
