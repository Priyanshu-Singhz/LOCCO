import UIKit
import MaterialComponents

class ProfileTextFieldTblViewCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var customTextField: MDCOutlinedTextField!
    @IBOutlet var progressBar: SMProgressBar!
    
    var textfieldDidChanged: ((String?, String?) -> ())? = nil
    var vmProfilePage = ViewModelProfilePage()
    override func awakeFromNib() {
        super.awakeFromNib()
        customTextField.delegate = self
    }
    
    func configure(with model: Rowmodel, at indexPath: IndexPath) {
        customTextField.accessibilityIdentifier = model.Identifier
        customTextField.label.text = model.placeholder?.translated
        customTextField.addTextChanges(self, action: #selector(textFieldTextChanged))
        if model.Identifier == TextFieldIdetifier.email.rawValue{
            customTextField.isUserInteractionEnabled = false
            customTextField.themeWhiteFill(isCustomColor: .textDisabled)
        } else {
            customTextField.isUserInteractionEnabled = true
            customTextField.themeWhiteFill()
        }
    }
    @objc func textFieldTextChanged(_ textField: MDCOutlinedTextField) {
        //textField.leadingAssistiveLabel.text = nil
        textfieldDidChanged?(textField.accessibilityIdentifier, textField.text)
        //vmProfilePage.textFieldTextChanged(textField)
    }
}
