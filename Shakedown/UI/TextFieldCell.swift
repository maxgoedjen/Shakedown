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
        textField.addTarget(self, action: "valueChanged:", forControlEvents: .EditingChanged)
    }
    
}

extension TextFieldCell {
    
    func valueChanged(textField: UITextField) {
        println(textField.text)
        delegate?.valueChanged(self, newValue: textField.text)
    }
    
}