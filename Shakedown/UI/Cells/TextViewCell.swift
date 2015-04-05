//
//  TextViewCell.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 3/18/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import UIKit

class TextViewCell: LabeledCell {
    
    @IBOutlet var textView: UITextView!
    @IBOutlet var placeholderLabel: UILabel!

    override class var identifier: String {
        return "TextViewCell"
    }
   
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.textContainerInset = UIEdgeInsets(top: 14, left: 3, bottom: 14, right: 3)
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
