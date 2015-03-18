//
//  TextFieldCell.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 3/17/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import UIKit

class TextFieldCell: ShakedownCell {
    
    @IBOutlet var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.delegate = self
    }
    
}

extension TextFieldCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(textField: UITextField) {
        delegate?.valueChanged(self, newValue: textField.text)
    }
    
}