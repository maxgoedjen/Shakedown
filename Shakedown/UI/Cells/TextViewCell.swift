import UIKit

class TextViewCell: LabeledCell {
    
    @IBOutlet var textView: UITextView!
    @IBOutlet var placeholderLabel: UILabel!

    override class var identifier: String {
        return "TextViewCell"
    }
   
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.textContainerInset = UIEdgeInsets(top: 14, left: 3, bottom: 0, right: 3)
    }
    
    class func heightForText(text: String, width: CGFloat) -> CGFloat {
        if text.isEmpty {
            return 50
        } else {
            let attributed = NSAttributedString(string: text, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(17)])
            let bounds = CGSize(width: width - 6, height: 0)
            return attributed.boundingRectWithSize(bounds, options: [.UsesLineFragmentOrigin, .UsesFontLeading], context: nil).size.height + 30
        }
    }
    
}

extension TextViewCell: UITextViewDelegate {
    
    func textViewDidChange(textView: UITextView) {
        delegate?.cell(self, valueChanged: textView.text)
        if textView.text.isEmpty {
            placeholderLabel.hidden = false
            hideLabel()
        } else {
            placeholderLabel.hidden = true
            showLabel()
        }
    }
    
}
