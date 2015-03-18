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

    override class var identifier: String {
        return "TextViewCell"
    }
   
}

extension TextViewCell: UITextViewDelegate {
    
    func textViewDidChange(textView: UITextView) {
        delegate?.cell(self, valueChanged: textView.text)
    }
    
}
