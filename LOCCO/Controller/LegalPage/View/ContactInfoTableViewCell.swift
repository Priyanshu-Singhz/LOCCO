//
//  HelpInfoTableViewCell.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 28/02/24.
//

import UIKit

class ContactInfoTableViewCell: UITableViewCell {
    //MARK: - Outlet's
    @IBOutlet var sendEmailLbl: UILabel!
    @IBOutlet var helloEmailLbl: UILabel!
    @IBOutlet var anyQuriesLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
       setupUI()
    }
    func setupUI(){
        anyQuriesLbl.text = "faq_support_page-contact-box-question".translated
        sendEmailLbl.text = "faq_support_page-contact-box-text".translated
        helloEmailLbl.text = "faq_support_page-contact-box-mail".translated
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    // Button Action
    @IBAction func emailBtnPressed(_ sender: UIControl) {
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
