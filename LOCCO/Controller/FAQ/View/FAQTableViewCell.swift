import UIKit

class FAQTableViewCell: UITableViewCell {
    @IBOutlet var questionLbl: UILabel!
    @IBOutlet var imgArrow: UIImageView!
    @IBOutlet var descriptionLbl: UILabel!
    
    var isExpanded = false {
        didSet {
            descriptionLbl.isHidden = !isExpanded
            imgArrow.image = isExpanded ? UIImage(named: "up_arrow") : UIImage(named: "down_arrow")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        descriptionLbl.isHidden = true // Initially hide the description text
    }

    func configure(_ model: Rowmodel) {
        questionLbl.text = model.title.translated
        descriptionLbl.text = model.subtitle?.translated
    }
}
