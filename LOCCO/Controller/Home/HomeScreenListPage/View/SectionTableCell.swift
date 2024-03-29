//
//  SectionTableCell.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 06/03/24.
//

import UIKit

class SectionTableCell: UITableViewCell {
    @IBOutlet weak var stackMain: UIStackView!
    @IBOutlet weak var icLeading: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var icTrailing: UIImageView!
    @IBOutlet var trailingLbl: UILabel!
    @IBOutlet weak var baseView: UIView!
    //MARK: - Properties
    var separatorView: CustomSeparatorView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSeparatorView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    // Table View Cell Style
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSeparatorView()
    }
    func setUpCell(_ model:Rowmodel,_ isLanguageChange:Bool = false){
        lblTitle.text = model.title.translated
        // To get update the Current Language
//        let lang  = UserDefaults.appObjectForKey("CurrentLanguage") as? String
        trailingLbl.text = model.trailingText
        // For only isLangauge Changed Screen
        if isLanguageChange{
            icTrailing.image = model.Identifier == AppLaunguage.shared.currentLanguage ? UIImage(systemName: "checkmark") : nil
            separatorView.backgroundColor = UIColor.textDisabled
        }
        icLeading.image = model.icon
        icLeading.isHidden = (model.icon == nil)
        icTrailing.isHidden = !model.isShowNextButton
        separatorView.isHidden = !model.isShowSeparatorLine
        trailingLbl.isHidden = !model.isTralingText
    }
    
    func setRoundedCorner(rowCount:Int, currentIndex:Int) {
        if rowCount == 0  { self.setAllRounded(radius: 16) }
        else if currentIndex == 0 { self.setTopRounded() }
        else if currentIndex == rowCount { self.setBottomRounded() }
        else { self.setAllRounded(radius: 0) }
    }
    
    private func setTopRounded() {
        baseView.roundCorners(corners: [.topLeft, .topRight], radius: 16)
    }
    
    private func setBottomRounded() {
        baseView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 16)
    }
    
    private func setAllRounded(radius:CGFloat) {
        baseView.roundCorners(corners: .allCorners, radius: radius)
    }
    //Set Up the SeparatorView
    private func setupSeparatorView() {
        separatorView = CustomSeparatorView(frame: .zero)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(separatorView)
        
        // Add constraints for separator view
        separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
}
