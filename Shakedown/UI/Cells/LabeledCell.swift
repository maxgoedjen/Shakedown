//
//  LabeledCell.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 4/5/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import UIKit

class LabeledCell: ShakedownCell {
    
    @IBOutlet var label: UILabel!
    @IBOutlet var labelTopConstraint: NSLayoutConstraint!
    @IBOutlet var contentConstraint: NSLayoutConstraint!
    
    func showLabel() {
        labelTopConstraint.constant = 5
        contentConstraint.constant = 5
        UIView.animateWithDuration(0.5) {
            self.label.alpha = 1
            self.layoutIfNeeded()
        }
    }
    
    func hideLabel() {
        labelTopConstraint.constant = 20
        contentConstraint.constant = 0
        UIView.animateWithDuration(0.5) {
            self.label.alpha = 0
            self.layoutIfNeeded()
        }
    }
    
}