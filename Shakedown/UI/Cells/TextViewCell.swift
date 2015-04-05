//
//  TextViewCell.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 3/18/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import UIKit

class TextViewCell: ShakedownCell {
    
    @IBOutlet var textView: UITextView!
    @IBOutlet var placeholderLabel: UILabel!
    @IBOutlet var label: UILabel!
    @IBOutlet var labelTopConstraint: NSLayoutConstraint!
    @IBOutlet var contentConstraint: NSLayoutConstraint!

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
            // Workaround for incorrect Swift 1.1 port of NSStringDrawingOptions to Int instead of RawOptionSetType. Fixed in 1.2
            let options = unsafeBitCast(NSStringDrawingOptions.UsesLineFragmentOrigin.rawValue |
                NSStringDrawingOptions.UsesFontLeading.rawValue,
                NSStringDrawingOptions.self)
            return attributed.boundingRectWithSize(bounds, options: options, context: nil).size.height + 30
        }
    }
    
    
    func showLabel(animated: Bool = true) {
        labelTopConstraint.constant = 5
        contentConstraint.constant = 5
        UIView.animateWithDuration(animated ? 0.5 : 0) {
            self.label.alpha = 1
            self.layoutIfNeeded()
        }
    }
    
    func hideLabel(animated: Bool = true) {
        labelTopConstraint.constant = 20
        contentConstraint.constant = 0
        UIView.animateWithDuration(animated ? 0.5 : 0) {
            self.label.alpha = 0
            self.layoutIfNeeded()
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
