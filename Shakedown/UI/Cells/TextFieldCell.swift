import UIKit

class TextFieldCell: LabeledCell {
    
    @IBOutlet var textField: UITextField!
    
    override class var identifier: String {
        return "TextFieldCell"
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        hideLabel(false)
        textField.enabled = true
    }
    
    override var shownContentConstraint: CGFloat {
        return 19
    }
    
    override var hiddenContentConstraint: CGFloat {
        return 14
    }

}

extension TextFieldCell {
    
    @IBAction func valueChanged(textField: UITextField) {
        delegate?.cell(self, valueChanged: textField.text ?? "")
        if let _ = textField.text?.isEmpty {
            hideLabel()
        } else {
            showLabel()
        }
    }
    
}

extension TextFieldCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        delegate?.cellCompletedEditing(self)
        return true
    }
    
}