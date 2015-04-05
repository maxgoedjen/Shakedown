//
//  TextFieldCell.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 3/17/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import UIKit

class TextFieldCell: LabeledCell {
    
    @IBOutlet var textField: UITextField!
    
    override class var identifier: String {
        return "TextFieldCell"
    }
    
}

extension TextFieldCell {
    
    @IBAction func valueChanged(textField: UITextField) {
        delegate?.cell(self, valueChanged: textField.text)
        if textField.text.isEmpty {
            hideLabel()
        } else {
            showLabel()
        }
    }
    
}